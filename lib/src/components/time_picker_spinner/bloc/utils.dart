int findClosestIndex(List<String> list, int target) {
  int closestIndex = 0;
  int smallestDifference = (target - int.parse(list[0])).abs();

  for (int i = 1; i < list.length; i++) {
    int currentDifference = (target - int.parse(list[i])).abs();
    if (currentDifference < smallestDifference) {
      smallestDifference = currentDifference;
      closestIndex = i;
    }
  }

  return closestIndex;
}
