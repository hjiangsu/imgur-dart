# DIAPI - Dart Imgur API Library
An unofficial Imgur library developed in Dart. This project is currently under heavy development and is **not** yet suitable for production. Use at your own risk.

## Getting Started
A Imgur client id must be registered in order to use this library. Check the following [site](https://apidocs.imgur.com/#authorization-and-oauth) for more information regarding how to retrieve a client id with Imgur.

### Authentication

Currently, functionality is limited to anonymous access. To generate a Imgur instance, the following parameters are required: `clientId`.
```dart
final Imgur imgur = Imgur(clientId: "client");
```

### Accessing Image Information
To access information for a given image, you must have either the `id` of the image, or a URL.

```dart
// Access a given image's information
imgur.image(id: "id").information;
```

## Implemented API endpoints
The following section describes all the endpoints that are currently implemented. Note that for the implemented endpoints, not all available parameters may be present.

### Image: [Partial]
- `/image/{{hash}}`

## Running Tests
To run tests defined in the `/test` directory, environment variables must first be passed in from a `.env` file otherwise tests may fail.

An example of a `.env` file is shown below (and also in `.example_env file`)
```
CLIENT_ID = clientId
```