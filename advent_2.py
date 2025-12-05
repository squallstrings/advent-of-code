def is_invalid_id(n: int) -> bool:
    # Part 1
    s = str(n)
    if len(s) % 2 != 0:
        return False
    half = len(s) // 2
    return s[:half] == s[half:]


def is_invalid_id2(n: int) -> bool:
    # Part 2
    s = str(n)
    length = len(s)

    for chunk_size in range(1, length // 2 + 1):
        if length % chunk_size != 0:
            continue

        chunk = s[:chunk_size]
        if chunk * (length // chunk_size) == s:
            return True

    return False


def solve(filename="input2.txt"):
    with open(filename) as f:
        raw = f.read().strip().split(",")

    part1 = 0
    part2 = 0

    for entry in raw:
        lo, hi = map(int, entry.split("-"))
        for n in range(lo, hi + 1):
            if is_invalid_id(n):
                part1 += n
            if is_invalid_id2(n):
                part2 += n

    print("Part 1:", part1)
    print("Part 2:", part2)


solve()
