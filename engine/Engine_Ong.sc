// CroneEngine_Ong
// Simulates Ocean Waves

// Deeply inspired by a Syntherjack pedal: https://syntherjack.net/ocean-noise-generator/

// Inherit methods from CroneEngine
Engine_Ong : CroneEngine {
	// Define a getter for the synth variable
	var <synth;

	// Define a class method when an object is created
	*new { arg context, doneCallback;
		// Return the object from the superclass (CroneEngine) .new method
		^super.new(context, doneCallback);
	}

	alloc {
		// synth
		SynthDef(\Ong, {
			arg out,
			overallAmpl=1.0,
			nearWavesBaseAmpl=0.7,
			nearWavesSpeedL=0.11,
			nearWavesSpeedR=0.13,
			nearWavesFilterCutoff=3000,
			farWavesBaseAmpl=0.5,
			farWavesSpeed=0.1,
			farWavesFilterCutoff=840,
			nearFoamAmpl=0.08,
			ambienceAmpl=0.003,
			ambienceFilterCutoff=10000;

			//---- LFOs
			var nearWavesAmplL = SinOsc.ar(nearWavesSpeedL, 0.0, nearWavesBaseAmpl);
			var nearFoamAmplL = SinOsc.ar(nearWavesSpeedL, 2*(pi/3), nearFoamAmpl);
			var nearWavesAmplR = SinOsc.ar(nearWavesSpeedR, 0.0, nearWavesBaseAmpl);
			var nearFoamAmplR = SinOsc.ar(nearWavesSpeedR, 2*(pi/3), nearFoamAmpl);
			var farWavesAmpl = SinOsc.ar(farWavesSpeed, 0.0, farWavesBaseAmpl);

			//---- sound generators
			var nearWavesL = LPF.ar(PinkNoise.ar(1.0, 0.0), nearWavesFilterCutoff, 1.0, 0.0);
			var nearFoamL = WhiteNoise.ar(1.0, 0.0);
			var nearWavesR = LPF.ar(PinkNoise.ar(1.0, 0.0), nearWavesFilterCutoff, 1.0, 0.0);
			var nearFoamR = WhiteNoise.ar(1.0, 0.0);
			var farWaves = LPF.ar(PinkNoise.ar(1.0, 0.0), farWavesFilterCutoff, 1.0, 0.0);
			var ambience = LPF.ar(WhiteNoise.ar(1.0, 0.0), ambienceFilterCutoff, 1.0, 0.0);

			// Create an output object
			Out.ar(out, [
				Mix.new([
					nearWavesL * 0.7 * nearWavesAmplL,
					nearWavesR * 0.1 * nearWavesAmplR,
					nearFoamL * nearFoamAmplL*nearFoamAmplL,
					ambience * ambienceAmpl,
					farWaves * farWavesAmpl
				]) * overallAmpl, // left stereo
				Mix.new([
					nearWavesL * 0.1 * nearWavesAmplL,
					nearWavesR * 0.7 * nearWavesAmplR,
					nearFoamR * nearFoamAmplR*nearFoamAmplR,
					ambience * ambienceAmpl,
					farWaves * farWavesAmpl
				]) * overallAmpl  // right stereo
			]);
		}).add;

		// foghorn as used by ships
		SynthDef(\Foghorn, {
			arg out, vol = 0.1;

			var pan = Rand(0.2, 0.8);
			var dur = Rand(2.0, 4.0);
			var freq = IRand(35, 60);
			var amp = Env([0, 1, 0.6, 0.8, 0], [0.1, 0.2, dur, 0.2]);
			var wave = Saw.ar(freq, 1.0);

			// FreeVerb.ar(in, mix, roomsize, damp, mul, add)
			var filtered = FreeVerb.ar(
				LPF.ar(
					Decay.ar(wave, 0.25, LFCub.ar(freq*2.04, 0, 0.2)),
					500,
					EnvGen.kr(amp)
			), 0.8, 0.7, 0.7, vol);

			filtered = Limiter.ar(filtered, 0.8);

			Out.ar(out, [filtered * pan, filtered * (1.0-pan)]);
			FreeSelfWhenDone.kr(Line.kr(vol, 0, dur+2));
		}).add;

		synth = Synth.new(\Ong);

		this.addCommand("amp", "f", { arg msg;
			synth.set(\overallAmpl, msg[1]);
		});
		this.addCommand("nearWavesAmp", "f", { arg msg;
			synth.set(\nearWavesBaseAmpl, msg[1]);
		});
		this.addCommand("farWavesAmp", "f", { arg msg;
			synth.set(\farWavesBaseAmpl, msg[1]);
		});
		this.addCommand("foam", "f", { arg msg;
			synth.set(\nearFoamAmpl, msg[1]);
		});
		this.addCommand("ambience", "f", { arg msg;
			synth.set(\ambienceAmpl, msg[1]);
		});
		this.addCommand("ambienceFilterCutoff", "f", { arg msg;
			synth.set(\ambienceFilterCutoff, msg[1]);
		});
		this.addCommand("nearWavesSpeed", "f", { arg msg;
			synth.set(\nearWavesSpeedL, msg[1] - (msg[1] * 0.06));
			synth.set(\nearWavesSpeedR, msg[1] + (msg[1] * 0.06));
		});
		this.addCommand("farWavesSpeed", "f", { arg msg;
			synth.set(\farWavesSpeed, msg[1]);
		});
		this.addCommand("nearWavesFilterCutoff", "f", { arg msg;
			synth.set(\nearWavesFilterCutoff, msg[1]);
		});
		this.addCommand("farWavesFilterCutoff", "f", { arg msg;
			synth.set(\farWavesFilterCutoff, msg[1]);
		});
		this.addCommand("triggerFoghorn", "b", { arg msg;
			// the Foghorn synthdef is self-freeing
			synth.get(\nearWavesBaseAmpl, {
				arg v;
				Synth.new(\Foghorn, [\vol, v]);
			});
		});
	}
	// define a function that is called when the synth is shut down
	free {
		synth.free;
	}
}
