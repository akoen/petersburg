function toss(n,N)
    if rand() > 1/2
        return 2^n
    elseif n > N
        return 0
    else
        return toss(n+1,N)
    end
end

function mat2latex(m::Matrix)
    s = mapslices(x -> join(x, " & "), string.(m), dims=2)
    return join(s, " \\\\\n")
end
