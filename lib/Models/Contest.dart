// It is a model for UPCOMING CONTESTS.

class Contest {
  final int id;
  final String name;
  final String type;
  final String phase;
  final int durationSeconds;
  final int startTimeSeconds;

  Contest(this.id, this.name, this.type, this.phase, this.durationSeconds,
      this.startTimeSeconds);
}
