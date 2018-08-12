function output = getithentry( this, elin )

output = [];
if isempty( this )
    return;
end

if elin <= length( this.pattern )

    if elin >= this.initime
        rowindx = mod( elin - this.initime , length(this.pattern) ) + 1;
        if rowindx<=length(this.pattern)
            output = this.pattern{rowindx};
        end
    end
end
