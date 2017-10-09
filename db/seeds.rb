require 'creator_helper'

# create users
lana = User.create(name: "Lana", email: "lana@haha.com", password: "poipoipoi")
bana = User.create(name: "Bana", email: "bana@haha.com", password: "poipoipoi")
fana = User.create(name: "Fana", email: "fana@haha.com", password: "poipoipoi")
# no song ana = (n)ana
nana = User.create(name: "Nana", email: "nana@haha.com", password: "poipoipoi")

# create songs for those users
# TODO super quick implementation, how can we diversify this?
CreatorHelper.populate_songs(lana)
CreatorHelper.populate_songs(bana)
CreatorHelper.populate_songs(fana)
