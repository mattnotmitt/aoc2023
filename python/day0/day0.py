from pathlib import Path

INPUT = Path(__file__).parent / "day3_example.txt"
# INPUT = Path(__file__).parent / "day3.txt"

def part1(input: list[str]) -> int:
    sum = 0
    for line in input:
        sum += 0

    return sum

def part2(input: list[str]) -> int:
    sum = 0
    for line in input:
        sum += 0

    return sum

if __name__ == '__main__':
    with open(INPUT) as f:
        data = f.read().splitlines()
        print(f"Part1: <desc>: {part1(data)}")
        print(f"Part2: <desc>: {part2(data)}")