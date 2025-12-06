

curtiss_r3c0={}

function curtiss_r3c0.register_parts_method(self)
    self.object:set_bone_position("aileron_base_l", {x=-36.031,y=9.62,z=-3.64}, {x=90,y=0,z=0})
    self.object:set_bone_position("aileron_base_r", {x=36.031,y=9.62,z=-3.64}, {x=90,y=0,z=0})

    local pos = self.object:get_pos()

    local cabin=minetest.add_entity(pos,'ww1_planes_lib:cabin')
    cabin:set_attach(self.object,'',{x=0,y=3.1,z=-1.02},{x=0,y=0,z=0})
    self.cabin = cabin

    --set stick position
    self.cabin:set_bone_position("stick", {x=0,y=-3.65,z=-4}, {x=0,y=0,z=0})
    self.cabin:set_bone_position("speed", {x=-0.84,y=4.6,z=-4.05}, {x=0,y=0,z=0})
    self.cabin:set_bone_position("fuel", {x=3,y=3.95,z=-4.05}, {x=0,y=0,z=0})
    self.cabin:set_bone_position("altimeter_pt_1", {x=-2.66,y=4.6,z=-4.05}, {x=0,y=0,z=0})
    self.cabin:set_bone_position("altimeter_pt_2", {x=-2.66,y=4.6,z=-4.05}, {x=0,y=0,z=0})
    self.cabin:set_bone_position("power", {x=1.04,y=4.6,z=-4.05}, {x=0,y=0,z=0})
    self.cabin:set_bone_position("climber", {x=0,y=4.6,z=-3}, {x=0,y=0,z=0})

    local altimeter = airutils.plot_altimeter_gauge(self, 500, 40, 25)
    local speed = airutils.plot_speed_gauge(self, 500, 150, 25)
    local rpm = airutils.plot_power_gauge(self, 500, 260, 25)
    local fuel = airutils.plot_fuel_gauge(self, 500, 380, 65)
    self.initial_properties.textures[9] = "airutils_brown.png"..altimeter..speed..rpm..fuel
end

function curtiss_r3c0.destroy_parts_method(self)
    if self.cabin then self.cabin:remove() end
end

function curtiss_r3c0.step_additional_function(self)
    local ailerons = self._rudder_angle
    if self._invert_ailerons then ailerons = ailerons * -1 end

    if (self.driver_name==nil) and (self.co_pilot==nil) then --pilot or copilot
        return
    end

    if self.co_pilot then
        self.object:set_bone_position("normal_cover", {x=0,y=0, z=0}, {x=0,y=0,z=0})
        self.object:set_bone_position("glass_cover", {x=0,y=7.15, z=12.74}, {x=-1.5,y=0,z=0})
    else
        self.object:set_bone_position("normal_cover", {x=0,y=7.15, z=12.74}, {x=-1.5,y=0,z=0})
        self.object:set_bone_position("glass_cover", {x=0,y=0, z=12.74}, {x=0,y=0,z=0})
    end

    self.object:set_bone_position("elevator_l", {x=0,y=0, z=0}, {x=-self._elevator_angle*2,y=0,z=0})
    self.object:set_bone_position("elevator_r", {x=0,y=0, z=0}, {x=-self._elevator_angle*2,y=0,z=0})

    --set stick position
    self.cabin:set_bone_position("stick", {x=0,y=-3.65,z=-4}, {x=self._elevator_angle/2,y=0,z=self._rudder_angle})

    --speed
    local speed_angle = airutils.get_gauge_angle(self._indicated_speed, -45)
    self.cabin:set_bone_position("speed", {x=-0.82,y=4.6,z=-4.05}, {x=0,y=0,z=speed_angle})

    --fuel
    local fuel_percentage = (self._energy*100)/self._max_fuel
    local fuel_angle = -(fuel_percentage*180)/100
    self.cabin:set_bone_position("fuel", {x=3,y=3.95,z=-4.05}, {x=0,y=0,z=fuel_angle})

    --altimeter
    local pos = self._curr_pos
    local altitude = (pos.y / 0.32) / 100
    local hour, minutes = math.modf( altitude )
    hour = math.fmod (hour, 10)
    minutes = minutes * 100
    minutes = (minutes * 100) / 100
    local minute_angle = (minutes*-360)/100
    local hour_angle = (hour*-360)/10 + ((minute_angle*36)/360)
    self.cabin:set_bone_position("altimeter_pt_1", {x=-2.66,y=4.6,z=-4.05}, {x=0,y=0,z=hour_angle})
    self.cabin:set_bone_position("altimeter_pt_2", {x=-2.66,y=4.6,z=-4.05}, {x=0,y=0,z=minute_angle})

    local power_indicator_angle = airutils.get_gauge_angle(self._power_lever/6.5)
    self.cabin:set_bone_position("power", {x=1.02,y=4.6,z=-4.05}, {x=0,y=0,z=power_indicator_angle-90})

    self.cabin:set_bone_position("climber", {x=0,y=4.6,z=-3}, {x=0,y=0,z=0})

end

curtiss_r3c0.plane_properties = {
	initial_properties = {
	    physical = true,
        collide_with_objects = true,
	    collisionbox = {-2.2, -3.4, -2.2, 2.2, 0.75, 2.2}, --{-1,0,-1, 1,0.3,1},
	    selectionbox = {-2.2, -0.5, -2.2, 2.2, 1.2, 2.2},
	    visual = "mesh",
        backface_culling = false,
	    mesh = "curtiss_r3c0.b3d",
        stepheight = 0.5,
        textures = {
                    "curtiss_uv_map.png", --controles
                    "curtiss_uv_map.png", --asa inf
                    "curtiss_uv_map.png", --asa sup
                    "airutils_brown.png", --banco
                    "airutils_brown.png", --borda nacele
                    "airutils_metal.png", --escapamento
                    "curtiss_uv_map.png", --cone helice
                    "airutils_grey.png", --interior
                    "airutils_brown.png", --panel
                    "curtiss_uv_map.png", --estab hor
                    "curtiss_uv_map.png", --radiador carenagem
                    "curtiss_uv_map.png", --flutuadores cima
                    "curtiss_uv_map.png", --mold parabrisa
                    "curtiss_uv_map.png", --fuselagem
                    "curtiss_uv_map3.png", --armas
                    "curtiss_uv_map.png", --montantes flutuadores
                    "curtiss_uv_map.png", --montante asas
                    "airutils_black.png", --nicho motor (escape)
                    "curtiss_uv_map.png", --nariz
                    "airutils_grey.png", --helice
                    "curtiss_uv_map.png", --suportes flutuadores
                    "airutils_transparent.png", --parabrisa
                    "curtiss_uv_map3.png", --radiador
                    "curtiss_uv_map3.png", --radiador
                    "curtiss_uv_map.png", --nacele armas
                    "airutils_red.png", 
                    "airutils_green.png",
                    "airutils_blue.png",
                    "airutils_metal.png",
                    },
    },
    textures = {},
    _anim_frames = 11,
    _unlock_roll = true,
	driver_name = nil,
	sound_handle = nil,
    owner = "",
    static_save = true,
    infotext = "",
    hp_max = 50,
    shaded = true,
    show_on_minimap = true,
    springiness = 0.1,
    buoyancy = 0.25,
    physics = airutils.physics,
    _vehicle_name = "Curtiss R3C-0",
    _needed_licence = ww1_planes_lib.licence_name,
    _use_camera_relocation = true,
    _seats = {{x=0,y=1,z=-12.5},},
    _seats_rot = {0,},  --necessary when using reversed seats
    _have_copilot = true, --wil use the second position of the _seats list
    _max_plane_hp = 50,
    _enable_fire_explosion = true,
    _longit_drag_factor = 0.120*0.120,
    _later_drag_factor = 2.0,
    _wing_angle_of_attack = 0.9,
    _wing_span = 14.5, --meters
    _min_speed = 7,
    _max_speed = 10,
    _max_fuel = 10,
    _speed_not_exceed = 25,
    _damage_by_wind_speed = 2,
    _hard_damage = true,
    _min_attack_angle = -1.2,
    _max_attack_angle = 90,
    _elevator_auto_estabilize = 100,
    _tail_lift_min_speed = 1,
    _tail_lift_max_speed = 3,
    _max_engine_acc = 10,
    _tail_angle = 0, --degrees
    _lift = 20,
    _trunk_slots = 2, --the trunk slots
    _rudder_limit = 20.0,
    _elevator_limit = 18.0,
    _elevator_response_attenuation = 10,
    _pitch_intensity = 0.4,
    _yaw_intensity = 20,
    _yaw_turn_rate = 10,
    _elevator_pos = {x=0, y=0, z=0},
    _rudder_pos = {x=0,y=10.82,z=-49.7287},
    _aileron_r_pos = {x=0,y=0,z=0}, --{x=36.031,y=9.62,z=-10},
    _aileron_l_pos = {x=0,y=0,z=0},
    _color = "#3c4956",
    _color_2 = "#e4af05",
    _rudder_angle = 0,
    _acceleration = 0,
    _engine_running = false,
    _angle_of_attack = 0,
    _elevator_angle = 0,
    _power_lever = 0,
    _last_applied_power = 0,
    _energy = 1.0,
    _last_vel = {x=0,y=0,z=0},
    _longit_speed = 0,
    _show_hud = false,
    _instruction_mode = false, --flag to intruction mode
    _command_is_given = false, --flag to mark the "owner" of the commands now
    _autopilot = false,
    _auto_pilot_altitude = 0,
    _last_accell = {x=0,y=0,z=0},
    _last_time_command = 1,
    _inv = nil,
    _inv_id = "",
    _collision_sound = "airutils_collision", --the col sound
    _engine_sound = "curtiss_engine",
    _painting_texture = {"airutils_painting.png","curtiss_uv_map.png",}, --the texture to paint
    _painting_texture_2 = {"airutils_painting_2.png",}, --"curtiss_uv_map2.png",}, --the texture to paint
    _mask_painting_associations = {["curtiss_uv_map.png"] = "curtiss_uv_map2.png^[multiply:#e4af05^curtiss_uv_map3.png", },
    _register_parts_method = curtiss_r3c0.register_parts_method, --the method to register plane parts
    _destroy_parts_method = curtiss_r3c0.destroy_parts_method,
    _plane_y_offset_for_bullet = 0,
    _custom_punch_when_attached = ww1_planes_lib._custom_punch_when_attached, --the method to execute click action inside the plane
    _custom_pilot_formspec = ww1_planes_lib.pilot_formspec,
    --_custom_pilot_formspec = airutils.pilot_formspec,
    _custom_step_additional_function = curtiss_r3c0.step_additional_function,
    _ground_friction = 0.965,
    _splash_x_position = 19,

    get_staticdata = airutils.get_staticdata,
    on_deactivate = airutils.on_deactivate,
    on_activate = airutils.on_activate,
    logic = airutils.logic,
    on_step = airutils.on_step,
    on_punch = airutils.on_punch,
    on_rightclick = airutils.on_rightclick,
}

dofile(minetest.get_modpath("curtiss_r3c0") .. DIR_DELIM .. "crafts.lua")
dofile(minetest.get_modpath("curtiss_r3c0") .. DIR_DELIM .. "entities.lua")

--
-- items
--

settings = Settings(minetest.get_worldpath() .. "/curtiss_r3c0_settings.conf")
local function fetch_setting(name)
    local sname = name
    return settings and settings:get(sname) or minetest.settings:get(sname)
end




