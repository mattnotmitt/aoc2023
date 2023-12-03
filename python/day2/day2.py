from collections import defaultdict
import functools
import operator
from pathlib import Path

INPUT = Path(__file__).parent / "day2_example.txt"
# INPUT = Path(__file__).parent / "day2.txt"

def checkGame(rounds, maxVal) -> int:
    [gameId, rounds] = rounds.split(": ")

    for round in rounds.split("; "):
        for count in round.split(", "):
            [num, colour] = count.split(" ")
            if int(num) > maxVal[colour]:
                return 0
            
    return int(gameId.split(" ")[1])


def part1(input: list[str], maxVal: dict[str, int] = {"red": 12, "green": 13, "blue": 14}) -> int:
    id_sum = 0
    for game in input:
        id_sum += checkGame(game, maxVal)

    return id_sum

def getPowers(rounds) -> int:
    [_, rounds] = rounds.split(": ")

    maxVals = defaultdict(lambda: 0)

    for round in rounds.split("; "):
        for count in round.split(", "):
            [num, colour] = count.split(" ")
            if int(num) > maxVals[colour]:
                maxVals[colour] = int(num)
    
    return functools.reduce(operator.mul, maxVals.values())

def part2(input: list[str]) -> int:
    power_sum = 0
    for game in input:
        power_sum += getPowers(game)
    return power_sum

if __name__ == '__main__':
    with open(INPUT) as f:
        data = f.read().splitlines()
        print(f"Part1: sum of game ids which are valid: {part1(data)}")
        print(f"Part2: sum of all game powers: {part2(data)}")