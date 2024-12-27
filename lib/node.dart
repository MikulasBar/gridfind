 
enum Node {
  idle,
  obstacle,
  open,
  closed;

  String toChar() {
    return switch (this) {
      idle => '.',
      obstacle => '#',
      open => 'O',
      closed => 'C',
    };
  }
}