import "dart:math" show Random;

class RandomIndex {
  RandomIndex(this.n);
  Random rand = new Random();
  int n;
  int get index => rand.nextInt(n);
}

void main(List<String> args) {
  // Number of reviews to generate.
  int reviews = int.parse(args.first, onError: (_) => 10);

  // Silly comment data.
  final input = <String, List<String>>{
    "name": ["Bob", "Jack", "Sue", "Jane", "Vivian"],
    "[adjective]": [
      " wonderful",
      "n amazing",
      " terrible",
      " mediocre",
      " spellbinding"
    ],
    "[verb]": ["giggle", "weep", "turn religious", "throw up", "dance"],
    "[emotion]": [
      "happiness",
      "sadness",
      "anger",
      "exasperation",
      "exhilharation"
    ]
  },
      commentTemplate =
          "A[adjective] tutorial that makes me want to [verb] with [emotion].",
      re = new RegExp(r"\[[^\]]+\]"),
      keys = re
          .allMatches(commentTemplate)
          .map((match) => match.group(0))
          .toList(),
      ri = new RandomIndex(5);

  // Silly comment generator.
  String randomComment() {
    String comment = commentTemplate;
    for (var key in keys) {
      comment = comment.replaceAll(key, input[key][ri.index]);
    }
    return comment;
  }

  // Output SQL.
  print("""

-- Output of script random-reviews.dart. ----------
INSERT INTO reviews
  (review_id, video_id, name, rating, review)
VALUES""");

  for (int i = 1; i <= reviews; i++) {
    String name = input["name"][ri.index], comment = randomComment();
    int video = ri.index + 1, score = ri.index + 1;
    print(
        "($i, $video, '$name', $score, '$comment')${i == reviews ? ";": ","}");
  }
  print("-- End of script's output. -------------------------\n");
}
