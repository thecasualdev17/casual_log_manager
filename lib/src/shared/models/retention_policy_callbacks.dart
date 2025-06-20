/// Callbacks for retention policy events, such as log addition, removal, cleanup, and updates.
class RetentionPolicyCallbacks {
  /// Called when a log is added.
  final Function? onLogAdded;

  /// Called before log cleanup begins.
  final Function? preLogCleanup;

  /// Called after log cleanup completes.
  final Function? postLogCleanup;

  /// Called when a log is removed.
  final Function? onLogRemoved;

  /// Called when all logs are cleared.
  final Function? onLogsCleared;

  /// Called when a log is updated.
  final Function? onLogUpdated;

  /// Creates a [RetentionPolicyCallbacks] instance with the given callbacks.
  ///
  /// [onLogAdded] is called when a log is added.
  /// [onLogRemoved] is called when a log is removed.
  /// [onLogsCleared] is called when all logs are cleared.
  /// [onLogUpdated] is called when a log is updated.
  /// [preLogCleanup] is called before log cleanup begins.
  /// [postLogCleanup] is called after log cleanup completes.
  RetentionPolicyCallbacks({
    this.onLogAdded,
    this.onLogRemoved,
    this.onLogsCleared,
    this.onLogUpdated,
    this.preLogCleanup,
    this.postLogCleanup,
  });

  /// Invokes the [onLogAdded] callback if set.
  void callOnLogAdded() {
    if (onLogAdded != null) {
      onLogAdded!();
    }
  }

  /// Invokes the [preLogCleanup] callback if set.
  void callPreLogCleanup() {
    if (preLogCleanup != null) {
      preLogCleanup!();
    }
  }

  /// Invokes the [postLogCleanup] callback if set.
  void callPostLogCleanup() {
    if (postLogCleanup != null) {
      postLogCleanup!();
    }
  }

  /// Invokes the [onLogRemoved] callback if set.
  void callOnLogRemoved() {
    if (onLogRemoved != null) {
      onLogRemoved!();
    }
  }

  /// Invokes the [onLogsCleared] callback if set.
  void callOnLogsCleared() {
    if (onLogsCleared != null) {
      onLogsCleared!();
    }
  }

  /// Invokes the [onLogUpdated] callback if set.
  void callOnLogUpdated() {
    if (onLogUpdated != null) {
      onLogUpdated!();
    }
  }
}
