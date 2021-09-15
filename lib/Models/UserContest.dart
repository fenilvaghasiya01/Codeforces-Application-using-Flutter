// It is a model for user's GIVEN CONTESTS

class PastContests {
  final int contestId;
  final String contestName;
  final int rank;
  final int oldRating;
  final int newRating;
  final DateTime date;
  PastContests(this.contestId, this.contestName, this.rank, this.oldRating,
      this.newRating, this.date);
}
