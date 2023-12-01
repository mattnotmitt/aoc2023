INPUT = "1/1.txt"

# this is a monstrosity
NUM_MAP = {
    "one": "o1e",
    "two": "t2o",
    "three": "t3e",
    "four": "f4r",
    "five": "f5e",
    "six": "s6x",
    "seven": "s7n",
    "eight": "e8t",
    "nine": "n9e"
}


def day1(input: list[str], replaceStr: bool = False) -> int:
    cal_sum = 0
    for line in input:
        print(line)
        if replaceStr:
            for s,n in NUM_MAP.items():
                line = line.replace(s, n)
        print(line)
        numeric = list(filter(lambda c: c.isnumeric(), line))
        print(numeric)
        cal_sum += int(numeric[0] + numeric[-1])
    return cal_sum


if __name__ == '__main__':
    with open(INPUT) as f:
        data = f.read().splitlines()
        print(f"Part1: sum of all calibration values: {day1(data)}")
        print(f"Part2: sum of all corrected calibration values: {day1(data, True)}")
        
