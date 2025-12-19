function main()
    lines = readlines(joinpath(@__DIR__, "input9.txt"))

    points = []

    for line in lines
        parts = split(line, ",")
        x = parse(Int, parts[1])
        y = parse(Int, parts[2])
        push!(points, (x, y))
    end

    max_area = 0

    for i = 1:length(points)
        for j = i+1:length(points)
            x1 = points[i][1]
            y1 = points[i][2]
            x2 = points[j][1]
            y2 = points[j][2]

            if x1 != x2 && y1 != y2
                width = abs(x1 - x2) + 1
                height = abs(y1 - y2) + 1
                area = width * height
                if area > max_area
                    max_area = area
                end
            end
        end
    end

    println(max_area)
end

main()
