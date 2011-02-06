package ands.fiano.sound.standingwave.instruments
{
    import ands.fiano.sound.standingwave.performance.*;

    import com.noteflight.standingwave3.performance.*;

    import flash.events.*;

    public interface IInstrument extends IEventDispatcher
    {
        function realize(note:PerformableNote, cache:Boolean=true):PerformableAudioSource;
    }
}
