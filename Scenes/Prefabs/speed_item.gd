extends Area2D

@export var speed_boost : float = 150.0   # ค่าความเร็วที่เพิ่มขึ้น
@export var jump_boost : float = 150.0    # ค่าแรงกระโดดที่เพิ่มขึ้น
@export var duration : float = 5.0        # ระยะเวลาของบัฟ (วินาที)
@export var respawn_time : float = 10.0   # เวลาที่ไอเทมจะเกิดใหม่ (วินาที) นับตั้งแต่ตอนเก็บ

func _on_body_entered(body):
	if body.name == "Player":
		# 1. ซ่อนไอเทมและปิดการชนทันที
		hide()
		if has_node("CollisionPolygon2D2"):
			$CollisionPolygon2D2.set_deferred("disabled", true)
		elif has_node("CollisionShape2D"):
			$CollisionShape2D.set_deferred("disabled", true)

		# 2. เพิ่มความเร็วและแรงกระโดดให้ผู้เล่น
		body.move_speed += speed_boost
		
		# *หมายเหตุ: ถ้าตัวละครคุณใช้ค่าติดลบในการกระโดด อาจจะต้องเปลี่ยนเป็น -= jump_boost
		body.jump_force += jump_boost 

		# 3. หน่วงเวลาตามจำนวนวินาทีของบัฟ
		await get_tree().create_timer(duration).timeout

		# 4. คืนค่าความเร็วและการกระโดดเท่าเดิม
		if is_instance_valid(body):
			body.move_speed -= speed_boost
			
			# *ต้องเปลี่ยนเครื่องหมายให้ตรงข้ามกับตอนที่เพิ่มค่าด้านบน
			body.jump_force -= jump_boost

		# 5. รอเวลาให้ไอเทมเกิดใหม่ (หักลบเวลาบัฟออกไปแล้ว)
		var wait_to_respawn = respawn_time - duration
		if wait_to_respawn > 0:
			await get_tree().create_timer(wait_to_respawn).timeout

		# 6. ไอเทมเกิดใหม่: แสดงภาพและเปิดการชนอีกครั้ง
		show()
		if has_node("CollisionPolygon2D2"):
			$CollisionPolygon2D2.set_deferred("disabled", false)
		elif has_node("CollisionShape2D"):
			$CollisionShape2D.set_deferred("disabled", false)
