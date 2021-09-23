import JSON
using Printf:@sprintf
using Base.Iterators:flatten
using Plots: plot, plot!, pyplot, theme

pyplot()

theme(:dark)

segments(timings) = [
    [
        (parse(Float64, t[1]), Float64(first(t[2]))),
        (parse(Float64, t[1]), Float64(last(t[2]))),
        (NaN, NaN)
    ] for t in filter(t -> length(t[2]) > 1, timings)
] |> flatten |> collect

function series(timings)
    s = []
    t = [[(parse(Float64, t[1]), Float64(r)) for r in t[2]] for t in timings]
    while !isempty(filter!(!isempty, t))
        push!(s, sort(popat!.(t, 1)))
    end
    s
end

function plots(jsons)
    ylims = getindex.(jsons, "timings") .|>
                flatten ∘ series |>
                flatten |>
                t -> (0.8 * minimum(last, t), 1.2 * maximum(last, t))
    plots = []
    for json in jsons
        plot(json["timings"] |> segments, labels=:none, linestyle=:dot)
        for (i, s) in json["timings"] |> series |> enumerate
            plot!(s,
                markershape=:circle,
                title=json["title"],
                legendtitle="completion refresh",
                legend=:outerright,
                labels=i |> i -> string(i, i < 4 ? ["st", "nd", "rd"][i] : "th", " refresh"),
                link=:all,
                xlabel="InsertCharPre",
                ylabel="CompleteChanged",
                yscale=:log10,
                yticks=ylims[1]:0.1:ylims[2],
                formatter=t -> @sprintf("%.1fs", t),
                seriestype=i > 1 ? :scatter : :path)
        end
        push!(plots, plot!())
    end
    plots
end

timings(files) = plot(plots(JSON.parsefile.(files))..., layout=(length(files), 1)) |> display

timings(ARGS)
