println("FILE LOADED")

function main()
    lines = readlines(joinpath(@__DIR__, "input9.txt"))

    red = Tuple{Int,Int}[]
    redset = Set{Tuple{Int,Int}}()

    for line in lines
        p = split(line, ",")
        pt = (parse(Int, p[1]), parse(Int, p[2]))
        push!(red, pt)
        push!(redset, pt)
    end

    n = length(red)

    hsegs = Tuple{Int,Int,Int}[]
    vsegs = Tuple{Int,Int,Int}[]

    for i = 1:n
        x1, y1 = red[i]
        x2, y2 = red[mod1(i + 1, n)]
        if y1 == y2
            a = min(x1, x2)
            b = max(x1, x2)
            push!(hsegs, (y1, a, b))
        else
            a = min(y1, y2)
            b = max(y1, y2)
            push!(vsegs, (x1, a, b))
        end
    end

    xb = Int[]
    yb = Int[]

    for (x, y) in red
        push!(xb, x); push!(xb, x + 1)
        push!(yb, y); push!(yb, y + 1)
    end

    for (y, x1, x2) in hsegs
        push!(xb, x1); push!(xb, x2 + 1)
        push!(yb, y); push!(yb, y + 1)
    end

    for (x, y1, y2) in vsegs
        push!(xb, x); push!(xb, x + 1)
        push!(yb, y1); push!(yb, y2 + 1)
    end

    sort!(xb); xb = unique(xb)
    sort!(yb); yb = unique(yb)

    xmin = xb[1]
    xmax = xb[end]
    ymin = yb[1]
    ymax = yb[end]

    pushfirst!(xb, xmin - 1)
    push!(xb, xmax + 1)
    pushfirst!(yb, ymin - 1)
    push!(yb, ymax + 1)

    sort!(xb); xb = unique(xb)
    sort!(yb); yb = unique(yb)

    xidx = Dict{Int,Int}()
    for i = 1:length(xb)
        xidx[xb[i]] = i
    end

    yidx = Dict{Int,Int}()
    for i = 1:length(yb)
        yidx[yb[i]] = i
    end

    W = length(xb) - 1
    H = length(yb) - 1

    wall = falses(H, W)

    for (y, x1, x2) in hsegs
        jy = yidx[y]
        ix1 = xidx[x1]
        ix2 = xidx[x2 + 1] - 1
        for ix = ix1:ix2
            wall[jy, ix] = true
        end
    end

    for (x, y1, y2) in vsegs
        ix = xidx[x]
        jy1 = yidx[y1]
        jy2 = yidx[y2 + 1] - 1
        for jy = jy1:jy2
            wall[jy, ix] = true
        end
    end

    outside = falses(H, W)
    qx = Int[]
    qy = Int[]
    head = 1

    function pushq(x::Int, y::Int)
        push!(qx, x)
        push!(qy, y)
    end

    pushq(1, 1)
    outside[1, 1] = true

    while head <= length(qx)
        x = qx[head]
        y = qy[head]
        head += 1

        if x > 1
            nx = x - 1; ny = y
            if !outside[ny, nx] && !wall[ny, nx]
                outside[ny, nx] = true
                pushq(nx, ny)
            end
        end
        if x < W
            nx = x + 1; ny = y
            if !outside[ny, nx] && !wall[ny, nx]
                outside[ny, nx] = true
                pushq(nx, ny)
            end
        end
        if y > 1
            nx = x; ny = y - 1
            if !outside[ny, nx] && !wall[ny, nx]
                outside[ny, nx] = true
                pushq(nx, ny)
            end
        end
        if y < H
            nx = x; ny = y + 1
            if !outside[ny, nx] && !wall[ny, nx]
                outside[ny, nx] = true
                pushq(nx, ny)
            end
        end
    end

    inside = falses(H, W)
    for j = 1:H
        for i = 1:W
            if !outside[j, i]
                inside[j, i] = true
            end
        end
    end

    wts = zeros(Int64, H, W)
    for j = 1:H
        dy = Int64(yb[j + 1] - yb[j])
        for i = 1:W
            if inside[j, i]
                dx = Int64(xb[i + 1] - xb[i])
                wts[j, i] = dx * dy
            end
        end
    end

    ps = zeros(Int64, H + 1, W + 1)
    for j = 1:H
        for i = 1:W
            ps[j + 1, i + 1] = ps[j, i + 1] + ps[j + 1, i] - ps[j, i] + wts[j, i]
        end
    end

    function rectsum(xl::Int, xr1::Int, yb0::Int, yt1::Int)
        ix1 = xidx[xl]
        ix2 = xidx[xr1] - 1
        iy1 = yidx[yb0]
        iy2 = yidx[yt1] - 1
        return ps[iy2 + 1, ix2 + 1] - ps[iy1, ix2 + 1] - ps[iy2 + 1, ix1] + ps[iy1, ix1]
    end

    max_area = Int64(0)

    for i = 1:n
        x1, y1 = red[i]
        for j = i+1:n
            x2, y2 = red[j]
            x1 == x2 && continue
            y1 == y2 && continue

            xl = min(x1, x2)
            xr = max(x1, x2)
            yb0 = min(y1, y2)
            yt = max(y1, y2)

            area = Int64(xr - xl + 1) * Int64(yt - yb0 + 1)
            area <= max_area && continue

            s = rectsum(xl, xr + 1, yb0, yt + 1)

            if s == area
                max_area = area
            end
        end
    end

    println(max_area)
end

main()
