# Transcript recorder plugin for Vorple

This is a plugin for [Vorple](https://vorple-if.com) to send playthrough transcripts of an Inform 7 game to a remote server while it's being played. It's meant primarily for [IFComp](https://ifcomp.org) entries but can be used with custom transcript recorder servers as well.

## Installation

Installation instructions are in the Inform 7 extension `Vorple Transcript Recorder.i7x` documentation. The extension is located in the `src` directory. Either download this entire repository (click the green `<> Code` button in GitHub and select "Download ZIP") or go to the `src` directory and download the file along with `transcript-recorder.js` from there (open the file in GitHub, click the "Download raw file" button which is located near the top right side of the page. The button icon has an arrow pointing down to a flat U shape.)

You can also use `transcript-recorder.min.js` in the `dist` directory which is a minified, slightly smaller version of the original. They are otherwise identical.

## Transcript data payload

The transcript data is sent in this JSON format:

```JSON
{
    "format": "simple",
    "sessionId": "123",
    "label": "My Story",
    "input": "get lamp",
    "output": "Taken.",
    "outtimestamp": 1234567890000,
    "timestamp": 1234567890000
}
```

-   `format`: Always "simple"
-   `sessionId`: A random string generated for each play session. The id stays the same during the session when the player is playing the game. This is used to determine which transcript the payload belongs to.
-   `label`: The name of the story (the story title in Inform)
-   `input`: The player input
-   `output`: The output given by the story in response to the input
-   `outtimestamp` and `timestamp`: When the payload was sent, Unix timestamp in milliseconds

This is sent after every turn as a POST request with the payload in the request body.

Available public JavaScript functions are commented in the `transcript-recorder.js` file (at the end, after a "public API" comment.) For troubleshooting a debugging mode can be switched on in the plugin with `vorpleTranscriptRecorder.toggleDebugMode(true)`. Debugging mode prints more messages to the browser's console if something goes wrong.
