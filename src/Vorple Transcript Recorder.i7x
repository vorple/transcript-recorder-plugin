Version 1 of Vorple Transcript Recorder (for Glulx only) by Juhana Leinonen begins here.

"Transcript recording for Vorple"

Use authorial modesty.

Transcript recording status is a truth state that varies. Transcript recording status is false.
	
To start transcript recording to URL (endpoint - text):
	execute JavaScript command "window.vorpleTranscriptRecorder.setEndpointUrl('[escaped endpoint]')";
	execute JavaScript command "return window.vorpleTranscriptRecorder.init('[escaped story title]')";
	now transcript recording status is true.
	
To start IFComp transcript recording:
	[find the IFComp entry id from the domain]
	execute JavaScript command "return Number(window.location.host.match(/\d+/)?.[bracket]0[close bracket])||0";
	let entry id be the number returned by the JavaScript command;
	if entry id is greater than 0:
		start transcript recording to URL "/play/[entry id]/transcribe";
	otherwise:
		execute JavaScript command "console.warn('Transcript recorder: Could not parse IFComp game id from the URL')".

To insert text/-- (message - text) in/to/into the/-- transcript:
	let insert be the escaped message using "\n" as line breaks;
	execute JavaScript command "window.vorpleTranscriptRecorder.insertText('[insert]')".

To pause transcript recording:
	execute JavaScript command "window.vorpleTranscriptRecorder.disable()";
	now transcript recording status is false.

To resume transcript recording:
	execute JavaScript command "window.vorpleTranscriptRecorder.enable()";
	now transcript recording status is true.

To start a/-- new transcript recording session:
	execute JavaScript command "window.vorpleTranscriptRecorder.restartSession()".


Vorple Transcript Recorder ends here.


---- DOCUMENTATION ----

This extension is for adding remote transcript recording capability to Vorple stories. It's mainly meant for IFComp entries but can also be used with a custom transcript recording service.


Chapter: Transcript recording for IFComp

The IFComp website offers transcript recording for standard Inform stories that take part in the competition. Vorple uses a custom interpreter so Vorple entries can't automatically use the same system. This extension sets up Vorple to send transcript data to the IFComp server so that Vorple authors can also get the same transcripts for their entries.

To set up the recorder, move the "transcript-recorder.js" file to the project's Materials folder and include it and this extension in the project. At the start of the story use "start IFComp transcript recording" to initialize the plugin.

	*: Include Vorple Transcript Recorder by Juhana Leinonen.

	Release along with JavaScript "transcript-recorder.js".

	When play begins:
		start IFComp transcript recording.

If the story uses a custom website instead of the default Inform 7 Vorple template the JavaScript file can also be bundled with other custom JavaScript files or included with script tags in the HTML page. In that case the "release along with..." line should be omitted.

Unfortunately since Vorple entries must be uploaded as websites, IFComp doesn't recognize that the story has transcripts available so there's no direct link to them in the author's entry management page. The link to the transcripts is https://ifcomp.org/entry/X/transcript where X is the entry id (for example https://ifcomp.org/entry/123/transcript). The entry id is shown in the "your current entries" list.

Note that due to browser security measures (CORS) transcript recording to IFComp only works if the story is running on IFComp's website. If the story is hosted somewhere else (e.g. itch.io or the author's own server) it can't send transcript data to IFComp.


Chapter: Pausing, resuming and restarting

The phrases to pause and resume transcript recording are:

	pause transcript recording;
	resume transcript recording;

While recording is paused no output is being collected for recording. New output gets sent only after recording is resumed again. The current status of recording can be checked with "if transcript recording status is true". The extension tracks the status based on only what's been done in Inform, it won't check if the browser is actually sending data successfully to the recorder server.

To restart recording completely:

	start a new transcript recording session;

This makes any future output be sent as if it were a completely new play session. This is useful for example if we want any restarts initiated by the player to be considered as new play sessions and recorded in separate transcripts.

These commands do nothing if the recording hasn't already been initialized earlier with "start IFComp transcript recording."


Chapter: Adding output manually

The transcript recorder works for any standard story output. Output that's printed outside the normal story flow can be added to the transcript manually:

	display a notification reading "You gained a point!";
	insert text "(player was awarded points, now has [score] points)" into the transcript;

The same method can be used to insert e.g. debugging data into the transcript.


Chapter: Using the recorder outside IFComp

The recorder can be used outside IFComp, for example if you host your own server that can collect recording data. The command to start the recorder in that case is:

	start transcript recording to URL "https://example.com/transcripts";

See the plugin's GitHub page for documentation on what kind of data the plugin sends to the server.
