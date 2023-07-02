import 'dart:async';
import 'dart:collection';

enum _QueueState { running, empty }

class Job<T> {
  final Queue<String> _jobsIdQueue = Queue();
  _QueueState _queueState = _QueueState.empty;
  final Map<String, T> _jobs = {};
  final StreamController<String> _jobQueueController =
      StreamController<String>();
  final Duration delay;

  Job({this.delay = const Duration(milliseconds: 50)});

  void add(T job) {
    final jobId = "Job_#${DateTime.now().microsecondsSinceEpoch}";
    _jobsIdQueue.add(jobId);
    _jobs[jobId] = job;
    if (_queueState == _QueueState.empty) _next();
  }

  void _delete() {
    _jobsIdQueue.removeFirst();
  }

  void _next() {
    if (_queueState != _QueueState.empty) _delete();
    _setQueueState(_QueueState.running);
    if (_jobsIdQueue.isNotEmpty && _jobs[_jobsIdQueue.first] != null) {
      _jobsSink.add(_jobsIdQueue.first);
    } else {
      _setQueueState(_QueueState.empty);
    }
  }

  void _setQueueState(_QueueState state) {
    _queueState = state;
  }

  void addListener(Function(T data) listener) {
    _jobsList.listen((event) async {
      final job = _jobs[event];
      if (job != null) await listener(job);
      Future.delayed(delay, () {
        _next();
      });
    });
  }

  Stream<String> get _jobsList => _jobQueueController.stream;
  StreamSink<String> get _jobsSink => _jobQueueController.sink;

  dispose() {
    _jobQueueController.close();
  }
}
