

function Pandoc(el)
    print("Pandoc detected!")
    print(el)

    -- return el
end




return {
    Pandoc=Pandoc,
    preprocess=preprocess
}