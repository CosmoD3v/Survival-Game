##MIT License
##
##Copyright (c) 2022 Fabian Keßler
##
##Permission is hereby granted, free of charge, to any person obtaining a copy
##of this software and associated documentation files (the "Software"), to deal
##in the Software without restriction, including without limitation the rights
##to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
##copies of the Software, and to permit persons to whom the Software is
##furnished to do so, subject to the following conditions:
##
##The above copyright notice and this permission notice shall be included in all
##copies or substantial portions of the Software.
##
##THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
##IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
##FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
##AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
##LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
##OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
##SOFTWARE.
##
##

## Smooth scroll functionality for ScrollContainer
##
## Applies velocity based momentum and "overdrag"
## functionality to a ScrollContainer
extends ScrollContainer

# Drag impact for one scroll input
export(float, 1, 5) var speed = 2
# Softness of damping when "overdragging"
export(float, 0, 1) var damping = .1

# Current velocity of the `content_node`
var velocity := Vector2(0,0)
# Below this value, velocity is set to `0`
var just_stop_under := 0.01
# Current counterforce for "overdragging" on the top
var over_drag_multiplicator_top := 1
# Current counterforce for "overdragging" on the bottom
var over_drag_multiplicator_bottom := 1
# Control node to move when scrolling
var content_node : Control
# Current position of `content_node`
var pos := Vector2(0, 0)
# When true, `content_node`'s position is only set by dragging the scroll bar
var scrolling := false


func _ready() -> void:
	get_v_scrollbar().connect("scrolling", self, "_on_VScrollBar_scrolling")
	for c in get_children():
		content_node = c
	self.get_v_scrollbar().rect_scale = Vector2(0, 0)


func _process(delta: float) -> void:
	# If no scroll needed, don't apply forces
	if content_node.rect_size.y - self.rect_size.y < 1:
		return
	
	var d := delta
	# Distance between content_node's bottom and bottom of the scroll box 
	var bottom_distance:= content_node.rect_position.y + content_node.rect_size.y - self.rect_size.y
	# Distance between content_node and top of the scroll box
	var top_distance:= content_node.rect_position.y
	
	# If overdragged on bottom:
	if bottom_distance< 0 :
		over_drag_multiplicator_bottom = 1/abs(bottom_distance)*10
	else:
		over_drag_multiplicator_bottom = 1

	# If overdragged on top:
	if top_distance> 0:
		over_drag_multiplicator_top = 1/abs(top_distance)*10
	else:
		over_drag_multiplicator_top = 1
	
	# Simulate friction
	velocity *= .9
	
	# If velocity is too low, just set it to 0
	if velocity.length() <= just_stop_under:
		velocity = Vector2(0,0)
	
	# Applies counterforces when overdragging
	if bottom_distance< 0 :
		velocity.y = lerp(velocity.y, -bottom_distance/10, damping)
	if top_distance> 0:
		velocity.y = lerp(velocity.y, -top_distance/10, damping)
	
	# If using scroll bar dragging, set the content_node's
	# position by using the scrollbar position
	if scrolling:
		pos = content_node.rect_position
		return
	
	# Move content node by applying velocity
	pos += velocity
	content_node.rect_position = pos
	
	# Update vertical scroll bar
	set_v_scroll(-pos.y)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not event.pressed:
			scrolling = false
		
		match event.button_index:
			BUTTON_WHEEL_DOWN:  velocity.y -= speed
			BUTTON_WHEEL_UP:    velocity.y += speed


func _on_VScrollBar_scrolling() -> void:
	scrolling = true


# Scrolls up a page
func scroll_page_up() -> void:
	velocity.y += self.rect_size.y / 10


# Scrolls down a page
func scroll_page_down() -> void:
	velocity.y -= self.rect_size.y / 10


# Adds velocity to the vertical scroll
func scroll_vertical(amount: float) -> void:
	velocity.y -= amount

# Scrolls to top
func scroll_to_top() -> void:
	# Reset velocity
	velocity.y = 0
	# Move content node to top
	pos.y = 0
	content_node.rect_position = pos
	# Update vertical scroll bar
	set_v_scroll(-pos.y)


# Scrolls to bottom
func scroll_to_bottom() -> void:
	# Reset velocity
	velocity.y = 0
	# Move content node to bottom
	pos.y = -content_node.rect_size.y + self.rect_size.y
	content_node.rect_position = pos
	# Update vertical scroll bar
	set_v_scroll(-pos.y)
