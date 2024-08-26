window.vorpleTranscriptRecorder = (() => {
    let debugMode = false;
    let endpointUrl = null;
    let isEnabled = false;
    let sessionId = null;
    let input = "";
    let output = "";
    let label = "";

    /**
     * Prints a debug message to the console if debug mode is on
     */
    function debug(message, severity) {
        if (!debugMode) {
            return;
        }

        const log = `Transcript recorder: ${message}`;

        if (severity === "warn" || severity === "error") {
            console[severity](log);
        } else {
            console.log(log);
        }
    }

    /**
     * Generates a new random session id
     */
    function generateSessionId() {
        sessionId =
            new Date().getTime().toString() +
            Math.ceil(Math.random() * 1000).toString();
    }

    /**
     * Saves the user's input for the current turn
     */
    function inputCollector(userInput) {
        try {
            input = userInput;
        } catch (e) {
            console.error(e);
        }

        return userInput;
    }

    /**
     * Saves the story output. Output doesn't come in all at once but in parts so it needs to be concatenated to one string before sending it at the end of the turn.
     */
    function outputCollector(text) {
        output += text;
    }

    /**
     * Send data to the recorder server endpoint
     */
    async function sendData(data) {
        if (!isEnabled) {
            debug("Plugin has been disabled, won't send data");
            return false;
        }

        if (!sessionId) {
            debug(
                "Session id has not been set, transcript recorder plugin has not been initialized?",
                "error"
            );
            return false;
        }

        if (!endpointUrl) {
            debug(
                "Can't send transcript data, endpoint URL has not been set",
                "error"
            );
            return false;
        }

        try {
            const request = await fetch(endpointUrl, {
                method: "POST",
                body: JSON.stringify(data),
                headers: {
                    "Content-Type": "application/json"
                }
            });

            if (!request.ok) {
                throw new Error(response.status);
            }
        } catch (e) {
            debug(
                "Error sending transcript data: " + (e.message ?? e),
                "error"
            );
            return false;
        }

        return true;
    }

    /**
     * Send all the turn data to the recorder server
     */
    function sendTurnData() {
        const now = new Date().getTime();
        const data = {
            sessionId,
            format: "simple",
            label,
            input,
            output,
            outtimestamp: now,
            timestamp: now
        };

        sendData(data);
        input = "";
        output = "";
    }

    // public API
    return {
        /**
         * Stops the transcript recording
         */
        disable: () => {
            isEnabled = false;
            input = "";
            output = "";
        },

        /**
         * Resumes transcript recording
         */
        enable: () => {
            isEnabled = true;
        },

        /**
         * Initialization function
         */
        init: storyName => {
            if (sessionId) {
                debug(
                    "Transcript recorder: tried to initialize multiple times",
                    "warn"
                );
                return;
            }

            if (typeof window.vorple !== "object") {
                throw new Error("Vorple has not been initialized");
            }

            label = storyName;
            generateSessionId();

            vorple.addEventListener("expectCommand", sendTurnData);
            vorple.prompt.addInputFilter(inputCollector);
            vorple.output.addOutputFilter(outputCollector);
            isEnabled = true;
        },

        /**
         * Adds additional text to the transcript. Note that "normal" story output is already added to the transcript automatically.
         */
        insertText: text => {
            window.haven.buffer.flush();
            output += text;
        },

        /**
         * Generates a new session id, which means future transcript data will be sent with the new id.
         * The recorder server considers the new id as part of a new play session.
         */
        restartSession: () => {
            if (sessionId) {
                generateSessionId;
            }
        },

        /**
         * Sets the recorder server URL where the data is sent
         */
        setEndpointUrl: url => (endpointUrl = url),

        /**
         * Is the recorder plugin enabled?
         */
        status: () => isEnabled,

        /**
         * Turns the debug mode on or off (pass true to turn on, false to turn off)
         */
        toggleDebugMode: status => (debugMode = status)
    };
})();
