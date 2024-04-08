import bpy
obj = bpy.context.active_object
modifier = next(i for i in obj.modifiers if i.type == 'CLOTH')

modifier.settings.quality = 19
modifier.settings.mass = 20.0
modifier.settings.air_damping = 10.0
modifier.settings.time_scale = 1.0
modifier.settings.tension_stiffness = 12.0
modifier.settings.compression_stiffness = 0.0
modifier.settings.shear_stiffness = 2.1999969482421875
modifier.settings.bending_stiffness = 0.0
modifier.settings.bending_model = 'ANGULAR'
modifier.settings.vertex_group_intern = ''
modifier.settings.pin_stiffness = 20.30000114440918
modifier.settings.use_dynamic_mesh = False
modifier.settings.use_internal_springs = True
modifier.settings.internal_tension_stiffness = 0.10000079870223999
modifier.settings.internal_compression_stiffness = 0.0
modifier.settings.internal_tension_stiffness_max = 15.0
modifier.settings.internal_compression_stiffness_max = 65.80000305175781
modifier.collision_settings.use_collision = True
modifier.settings.use_pressure = True
modifier.settings.uniform_pressure_force = 0.37999987602233887
modifier.settings.shrink_min = 0.0
modifier.settings.use_dynamic_mesh = False
modifier.settings.use_pressure_volume = False
modifier.settings.target_volume = 0.0
modifier.settings.pressure_factor = 10000.0
modifier.settings.fluid_density = 5.0
modifier.collision_settings.collision_quality = 4
modifier.collision_settings.distance_min = 0.005834862124174833
modifier.collision_settings.use_self_collision = False
modifier.collision_settings.self_friction = 5.0
modifier.collision_settings.self_distance_min = 0.014999999664723873
modifier.collision_settings.self_impulse_clamp = 0.0
modifier.settings.vertex_group_mass = 'Pin'
modifier.settings.tension_stiffness_max = 278.0999755859375
modifier.settings.compression_stiffness_max = 116.59999084472656
modifier.settings.shear_stiffness_max = 10000.0
modifier.settings.bending_stiffness_max = 500.0
modifier.settings.use_sewing_springs = False
modifier.settings.sewing_force_max = 0.0
modifier.settings.effector_weights.gravity = 1.0
modifier.settings.effector_weights.all = 1.0
modifier.settings.effector_weights.force = 1.0
modifier.settings.effector_weights.vortex = 1.0
modifier.settings.effector_weights.magnetic = 1.0
modifier.settings.effector_weights.harmonic = 1.0
modifier.settings.effector_weights.charge = 1.0
modifier.settings.effector_weights.lennardjones = 1.0
modifier.settings.effector_weights.wind = 1.0
modifier.settings.effector_weights.curve_guide = 1.0
modifier.settings.effector_weights.texture = 1.0
modifier.settings.effector_weights.smokeflow = 1.0
modifier.settings.effector_weights.turbulence = 1.0
modifier.settings.effector_weights.drag = 1.0
modifier.settings.effector_weights.boid = 1.0
