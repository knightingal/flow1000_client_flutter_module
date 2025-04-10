
class SlotItem {
  final int index;
  final double scrollOffset;
  final double itemHeight;
  final int slotIndex;

  SlotItem(this.index, this.scrollOffset, this.itemHeight, this.slotIndex);
}

class Slot {
  final List<SlotItem> slotItemList = [];
  double totalHeight = 0;

  SlotItem itemByIndex(int index) {
    return slotItemList.firstWhere((item) {
      return item.index == index;
    });
  }

  bool existByIndex(int index) {
    return slotItemList.any((item) => item.index == index);
  }
}
int minSlot(List<Slot> slot) {
  double min = slot[0].totalHeight;
  int index = 0;
  for (int i = 0; i < slot.length; i++) {
    if (slot[i].totalHeight < min) {
      min = slot[i].totalHeight;
      index = i;
    }
  }
  return index;
}