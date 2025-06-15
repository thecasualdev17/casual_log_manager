class RetentionPolicyCallbacks {
  final Function? onLogAdded;
  final Function? preLogCleanup;
  final Function? postLogCleanup;
  final Function? onLogRemoved;
  final Function? onLogsCleared;
  final Function? onLogUpdated;

  RetentionPolicyCallbacks({
    this.onLogAdded,
    this.onLogRemoved,
    this.onLogsCleared,
    this.onLogUpdated,
    this.preLogCleanup,
    this.postLogCleanup,
  });

  void callOnLogAdded() {
    if (onLogAdded != null) {
      onLogAdded!();
    }
  }

  void callPreLogCleanup() {
    if (preLogCleanup != null) {
      preLogCleanup!();
    }
  }

  void callPostLogCleanup() {
    if (postLogCleanup != null) {
      postLogCleanup!();
    }
  }

  void callOnLogRemoved() {
    if (onLogRemoved != null) {
      onLogRemoved!();
    }
  }

  void callOnLogsCleared() {
    if (onLogsCleared != null) {
      onLogsCleared!();
    }
  }

  void callOnLogUpdated() {
    if (onLogUpdated != null) {
      onLogUpdated!();
    }
  }
}
