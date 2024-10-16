extern crate paho_mqtt as mqtt;
extern crate reqwest;
extern crate serde;
extern crate serde_json;
extern crate warp;

use std::collections::HashMap;
use std::sync::{Arc, Mutex};
use std::time::Duration;
use serde::{Deserialize, Serialize};
use reqwest::Client;
use warp::{Filter, Rejection, Reply};
use warp::http::StatusCode;
use warp::reject::Reject;

#[derive(Serialize, Deserialize, Debug)]
struct Table {
    id: String,
    is_available: bool,
}

#[derive(Serialize, Deserialize, Debug)]
struct TableResponse {
    table: Table,
}

struct AppState {
    mqtt_client: mqtt::Client,
}

// Define a custom error type
#[derive(Debug)]
struct CustomError {
    message: String,
}

// Implement the Reject trait for CustomError
impl Reject for CustomError {}

#[tokio::main]
async fn main() {
    // Initialize MQTT client
    let mqtt_host = "tcp://broker.emqx.io:1883";
    let client_id = "RustMQTTClient";
    let command_topic = "esp32/commands";

    let create_opts = mqtt::CreateOptionsBuilder::new()
        .server_uri(mqtt_host)
        .client_id(client_id)
        .finalize();

    let mqtt_client = mqtt::Client::new(create_opts).expect("Failed to create MQTT client");
    let conn_opts = mqtt::ConnectOptionsBuilder::new()
        .keep_alive_interval(Duration::from_secs(20))
        .finalize();
    mqtt_client.connect(conn_opts).expect("Failed to connect to MQTT broker");

    let state = Arc::new(Mutex::new(AppState { mqtt_client }));

    // Serve the HTML file
    let html_route = warp::path::end()
        .map(|| warp::reply::html(include_str!("../rust.html"))); // Adjust the path

    // Check availability route
    let route = warp::path("check_availability")
        .and(warp::query::<HashMap<String, String>>())
        .and_then({
            let state = state.clone();
            move |query: HashMap<String, String>| {
                let table_id = query.get("table_id").unwrap().clone();
                let state = state.clone();

                async move {
                    let http_client = Client::new();
                    let api_url = format!("http://localhost:8080/tables/{}", table_id);

                    match http_client.get(&api_url).send().await {
                        Ok(response) => {
                            if response.status().is_success() {
                                let raw_json = response.text().await.unwrap();
                                let table_response: TableResponse = serde_json::from_str(&raw_json).unwrap();
                                let is_available = table_response.table.is_available;

                                // Publish to MQTT
                                let command = if is_available {
                                    r#"{"command":"green"}"#
                                } else {
                                    r#"{"command":"red"}"#
                                };

                                let msg = mqtt::Message::new(command_topic, command, 0);
                                let mqtt_client = state.lock().unwrap().mqtt_client.clone();
                                mqtt_client.publish(msg).expect("Failed to send command");

                                Ok(warp::reply::json(&serde_json::json!({ "is_available": is_available })))
                            } else {
                                Err(warp::reject::custom(CustomError {
                                    message: "Failed to fetch table info".to_string(),
                                }))
                            }
                        }
                        Err(_) => Err(warp::reject::custom(CustomError {
                            message: "Failed to send request".to_string(),
                        })),
                    }
                }
            }
        })
        .recover(|err: Rejection| async move {
            // Check if the rejection was due to our custom error
            if let Some(custom_error) = err.find::<CustomError>() {
                Ok::<_, warp::Rejection>(warp::reply::with_status(
                    warp::reply::json(&serde_json::json!({ "error": custom_error.message })),
                    StatusCode::INTERNAL_SERVER_ERROR,
                ))
            } else {
                Ok::<_, warp::Rejection>(warp::reply::with_status(
                    warp::reply::json(&serde_json::json!({ "error": "Unknown error" })),
                    StatusCode::INTERNAL_SERVER_ERROR,
                ))
            }
        });

    // Combine routes
    let routes = html_route
        .or(route)
        .recover(|err: Rejection| async move {
            Ok::<_, Rejection>(warp::reply::with_status(
                warp::reply::json(&serde_json::json!({ "error": "Route not found or invalid" })),
                StatusCode::NOT_FOUND,
            ))
        });

    // Start the server
    warp::serve(routes)
        .run(([127, 0, 0, 1], 3030))
        .await;
}