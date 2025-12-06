
--
-- entity
--

curtiss_r3c0.vector_up = vector.new(0, 1, 0)

minetest.register_entity("curtiss_r3c0:curtiss_r3c0", 
    airutils.properties_copy(curtiss_r3c0.plane_properties)
)
