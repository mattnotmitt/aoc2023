from collections import defaultdict
from dataclasses import dataclass, field
import functools
import json
import operator
from pathlib import Path

# INPUT = Path(__file__).parent / "day3_example.txt"
INPUT = Path(__file__).parent / "day3.txt"

@dataclass()
class Symbol:
    def __hash__(self):
        return hash((self.x, self.y))

    x: int
    y: int
    symbol: str
    ratios: list[int] = field(default_factory=list)

def locate_symbols(input: list[str]) -> dict[int, dict[int, bool|Symbol]]:
    symbol_map = defaultdict(lambda: defaultdict(lambda: False))
    for x,line in enumerate(input):
        for y,c in enumerate(line):
            if not c.isnumeric() and c != ".":
                s = Symbol(x, y, symbol=c)
                symbol_map[x-1][y-1] = s
                symbol_map[x-1][y] = s
                symbol_map[x-1][y+1] = s
                symbol_map[x][y-1] = s
                symbol_map[x][y] = s
                symbol_map[x][y+1] = s
                symbol_map[x+1][y-1] = s
                symbol_map[x+1][y] = s
                symbol_map[x+1][y+1] = s
    return symbol_map

def lookup_part_numbers(input: list[str], symbol_map: dict[int, dict[int, bool]]) -> list[int]:
    part_numbers = []
    for x,line in enumerate(input):
        current_number = ""
        current_number_is_part_number = False
        for y,c in enumerate(line):
            if c.isnumeric():
                current_number += c
                current_number_is_part_number |= symbol_map[x][y] != False
            else:
                if len(current_number) > 0 and current_number_is_part_number:
                    part_numbers.append(int(current_number))
                current_number = ""
                current_number_is_part_number = False
        if len(current_number) > 0 and current_number_is_part_number:
            part_numbers.append(int(current_number))
    return part_numbers

def part1(input: list[str]) -> int:
    # find symbols
    symbol_map = locate_symbols(input)
    # lookup part numbers
    part_numbers = lookup_part_numbers(input, symbol_map)

    return functools.reduce(operator.add, part_numbers)

def set_gear_ratios(input: list[str], symbol_map: dict[int, dict[int, bool]]) -> list[int]:
    gears = set()
    for x,line in enumerate(input):
        current_number = ""
        current_gear: Symbol | None = None
        for y,c in enumerate(line):
            if c.isnumeric():
                current_number += c
                if not current_gear and symbol_map[x][y] and symbol_map[x][y].symbol == "*":
                    current_gear = symbol_map[x][y]
            else:
                if len(current_number) > 0 and current_gear:
                    current_gear.ratios.append(int(current_number))
                    gears.add(current_gear)
                current_number = ""
                current_gear = None
        if len(current_number) > 0 and current_gear:
            current_gear.ratios.append(int(current_number))
            gears.add(current_gear)
    return filter(lambda g: len(g.ratios) == 2, gears)

def part2(input: list[str]) -> int:
    sum = 0
    # find symbols
    symbol_map = locate_symbols(input)
    # lookup part numbers
    gears = set_gear_ratios(input, symbol_map)

    return functools.reduce(lambda e,g: e + g.ratios[0] * g.ratios[1], gears, 0)

if __name__ == '__main__':
    with open(INPUT) as f:
        data = f.read().splitlines()
        print(f"Part1: sum of all part numbers: {part1(data)}")
        print(f"Part2: sum of all gear ratios: {part2(data)}")