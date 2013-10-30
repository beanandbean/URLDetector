import json

f = open("../data/login.data")
data = [[part.strip() for part in line.split(">", 1)] for line in f.readlines()]
f.close()

d = dict()
for names, address in data:
    name_array = names.split("|")
    for name in name_array:
        origin_name = str()
        index = 0
        try:
            while True:
                char = name[index]
                if char == "\\":
                    hex_string = name[index + 1: index + 3]
                    char = chr(int(hex_string, 16))
                    index += 3
                else:
                    index += 1
                origin_name += char
        except IndexError:
            pass
        d[origin_name] = address

f = open("../generated/website_dictionary.json", "w")
json.dump(d, f)
f.close()

print "Finish processing with %d items." % len(d)
