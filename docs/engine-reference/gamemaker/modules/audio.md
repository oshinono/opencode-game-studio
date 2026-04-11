# GameMaker Studio — Audio Quick Reference

Last verified: 2026-04-08 | Engine: 2024.13

## Audio Groups

Audio Groups (defined in the IDE) allow batch control of volume and pausing.
Use them to separate music, SFX, UI sounds, and ambient layers.

```gml
// Assign sounds to groups in the IDE Sound Editor → Audio Group
// Then control group volume at runtime:
audio_group_set_gain(audio_group_music, 0.6, 0);    // instant
audio_group_set_gain(audio_group_sfx, 1.0, 500);    // fade over 500ms
audio_group_pause(audio_group_music);
audio_group_resume(audio_group_music);

// Check group volume
var vol = audio_group_get_gain(audio_group_sfx);
```

## Playing Sounds

```gml
// Basic play
var inst = audio_play_sound(snd_jump, 10, false);  // sound, priority, loop

// Play at world position (positional audio)
var inst = audio_play_sound_at(snd_explosion, x, y, 0, 300, 600, 1, false, 10);
// (sound, x, y, z, falloff_min, falloff_max, falloff_factor, loop, priority)

// Play on a specific audio bus
var inst = audio_play_sound_on(audio_bus_master, snd_music, true, 5);

// 2024.11+: Play on an emitter for spatial positioning
var emitter = audio_emitter_create();
audio_emitter_position(emitter, x, y, 0);
var inst = audio_play_sound_on(emitter, snd_ambient, true, 1);
```

## Controlling Sound Instances

```gml
// Store the returned instance to control playback
var music_inst = audio_play_sound(snd_bgm, 1, true);

audio_sound_gain(music_inst, 0.5, 1000);  // fade to 0.5 over 1s
audio_pause_sound(music_inst);
audio_resume_sound(music_inst);
audio_stop_sound(music_inst);

// Check if still playing
if (audio_is_playing(music_inst)) { ... }

// Loop points
audio_sound_loop_start(music_inst, 4.0);  // loop from 4 seconds
audio_sound_loop_end(music_inst, 32.0);   // loop to 32 seconds
```

## Async Sound Events

Long loads and streaming completions fire in `Async - Audio Playback` event:

```gml
// Async Audio Playback Event
if (async_load[? "type"] == "audio_playback_error") {
    var snd = async_load[? "sound_id"];
    show_debug_message("Audio failed: " + audio_get_name(snd));
}
```

## Audio Formats and Compression

| Format | Type | Use For |
|--------|------|---------|
| WAV | Uncompressed | Short SFX — lowest latency |
| OGG | Compressed Streaming | Music, long ambience |
| MP4/AAC | Compressed Streaming | Music (iOS/HTML5 compatible) |

**Compressed — Streamed**: Audio is decoded from disk in real time.
Good for music. Set in Sound Editor → "Compressed - Streamed".

**Compressed — Decompressed on Load**: Decoded into RAM when game starts.
Good for frequently played SFX with moderate length.

## Common Pitfalls

- `audio_play_sound()` returns an **instance** ID — store it if you need to
  control or stop the sound later; ignoring the return makes stopping impossible
- If a sound uses a macro reference and "Remove Unused Assets" is ON, wrap the
  audio call in `gml_pragma("MarkTagAsUsed", "MyTag")` to prevent it being stripped
- `audio_sound_loop_start()` without an `audio_sound_loop_end()` now works
  correctly as of 2024.13 (was broken on HTML5 in earlier versions)
- Sound assets referenced only through macros (not by asset name directly) can
  be incorrectly removed by the "Remove Unused Assets" pass — fixed in 2024.13
  but verify on older runtimes
