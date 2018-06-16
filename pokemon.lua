local Pokemon = {}
Pokemon.__index=Pokemon
function Pokemon.new(ref_id, stats)
    local pokemon={id=ref_id, stats=stats}
    return setmetatable(pokemon, Pokemon)
end
