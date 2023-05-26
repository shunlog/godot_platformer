project=godot
itch_link=shunlog/terraria-clone:html

.PHONY: build/HTML5 itch status_itch

build/HTML5:
	godot --path $(project) --export HTML5

build/HTML5.zip: build/HTML5
	zip -r build/HTML5.zip build/HTML5

itch: build/HTML5.zip
	butler push build/HTML5.zip $(itch_link)
