# aggregating-emitter

Provides a mixing which enhances [component-emitter](https://github.com/component/emitter).
One can stop the normal emitting of events. All ```emit``` calls are recorded and will
be executed when emitting events is started again. For each event type only the most recent
recorded emit will be executed.

## API

### ```#stopEvents()```

Called to stop normal emitting of events. Events will be recorded and execution on the next
call to ```continueEvents```.

### ```#continueEvents()```

Called to execute the emits which were recorded since the last call to ```stopEvents```.

## Example

    function MyModel() {}

    MyModel.prototype.setValue = function(value) {
        this.value = value;
        this.emit('chage', value);
    }

    // call the mixin
    AggregatingEmitter(MyModel);

    m = new MyModel();

    // immediately emits the change event
    m.setValue(10);

    MyModel.stopEvents()

    // no change events emitted
    m.setValue(20);
    m.setValue(30);

    // emits a single change event with value 30
    MyModel.continueEvents();
