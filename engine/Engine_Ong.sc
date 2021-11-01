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
	// Rather than defining a SynthDef, use a shorthand to allocate a function and send it to the engine to play
	// Defined as an empty method in CroneEngine
	// https://github.com/monome/norns/blob/master/sc/core/CroneEngine.sc#L31
	alloc {
		// Define the synth variable, which is a function
		synth = {
			// define arguments to the function
			arg out,
				overallAmpl=1.0,
				nearWavesBaseAmpl=0.7,
				nearWavesSpeedL=0.15,
				nearWavesSpeedR=0.17,
				nearWavesFilterCutoff=3000,
				farWavesBaseAmpl=0.5,
				farWavesSpeed=0.13,
				farWavesFilterCutoff=840,
				nearFoamAmpl=0.002,
				ambienceAmpl=0.003;

			//---- LFOs
			var nearWavesAmplL = SinOsc.kr(nearWavesSpeedL, 0.0, nearWavesBaseAmpl, nearWavesBaseAmpl + 0.1);
			var nearFoamAmplL = SinOsc.kr(nearWavesSpeedL, pi / 2, nearFoamAmpl, -1 * nearFoamAmpl);
			var nearWavesAmplR = SinOsc.kr(nearWavesSpeedR, 0.0, nearWavesBaseAmpl, nearWavesBaseAmpl + 0.1);
			var nearFoamAmplR = SinOsc.kr(nearWavesSpeedR, pi / 2, nearFoamAmpl, -1 * nearFoamAmpl);
			var farWavesAmpl = SinOsc.kr(farWavesSpeed, 0.0, farWavesBaseAmpl, farWavesBaseAmpl + 0.1);

			//---- sound generators
			var nearWavesL = LPF.ar(PinkNoise.ar(nearWavesAmplL, 0.0), nearWavesFilterCutoff, 1.0, 0.0);
			var nearFoamL = WhiteNoise.ar(nearFoamAmplL, 0.0);
			var nearWavesR = LPF.ar(PinkNoise.ar(nearWavesAmplR, 0.0), nearWavesFilterCutoff, 1.0, 0.0);
			var nearFoamR = WhiteNoise.ar(nearFoamAmplR, 0.0);
			var farWaves = LPF.ar(PinkNoise.ar(farWavesAmpl, 0.0), farWavesFilterCutoff, 1.0, 0.0);
			var ambience = WhiteNoise.ar(ambienceAmpl, 0.0);

			// Create an output object
			Out.ar(out, [
				Mix.new([
					nearWavesL * 0.7 * overallAmpl,
					nearWavesR * 0.1 * overallAmpl,
					nearFoamL * overallAmpl,
					ambience * overallAmpl,
					farWaves * overallAmpl
				]), // left stereo
				Mix.new([
					nearWavesL * 0.1 * overallAmpl,
					nearWavesR * 0.7 * overallAmpl,
					nearFoamR * overallAmpl,
					ambience * overallAmpl,
					farWaves * overallAmpl
				])  // right stereo
			]);


		// Send the synth function to the engine as a UGen graph.
		}.play(args: [\out, context.out_b], target: context.xg);

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
	}
	// define a function that is called when the synth is shut down
	free {
		synth.free;
	}
}
