use std::fs;

fn main(){
    let s = fs::read_to_string("input4.txt").unwrap();
    let g: Vec<Vec<u8>> = s.lines().map(|l| l.as_bytes().to_vec()).collect();
    let h = g.len();
    let w = g[0].len();
    
    let dirs = [
        (-1,-1), (-1,0), (-1,1),
        (0,-1),          (0,1),
        (1,-1),  (1,0),  (1,1)
    ];

    let mut cnt = 0;

    for y in 0..h {
        for x in 0..w {
            if g[y][x] != b'@' { continue; }
            let mut n = 0;

            for (dy, dx) in &dirs {
                let ny = y as isize + dy;
                let nx = x as isize + dx;
                if ny < 0 || nx < 0 { continue; }
                let ny = ny as usize;
                let nx = nx as usize;
                if ny >= h || nx >= w { continue; }
                if g[ny][nx] == b'@' { n += 1; }
            }

            if n < 4 { cnt += 1; }
        }
    }
    let mut g2 = g.clone();
    let mut total = 0;

    loop {
        let mut rem = Vec::new();

        for y in 0..h {
            for x in 0..w {
                if g2[y][x] != b'@' { continue; }

                let mut n = 0;
                for (dy, dx) in &dirs {
                    let ny = y as isize + dy;
                    let nx = x as isize + dx;
                    if ny < 0 || nx < 0 { continue; }
                    let ny = ny as usize;
                    let nx = nx as usize;
                    if ny >= h || nx >= w { continue; }
                    if g2[ny][nx] == b'@' { n += 1; }
                }

                if n < 4 { rem.push((y,x)); }
            }
        }

        if rem.is_empty() { break; }

        total += rem.len();
        for (y,x) in rem {
            g2[y][x] = b'.';
        }
    }

    println!("{}", total);

    println!("{}", cnt);
}
