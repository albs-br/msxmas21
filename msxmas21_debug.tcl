ram_watch   add     0xc002      -type byte      -desc PlayerX                   -format dec
ram_watch   add     0xc003      -type byte      -desc PlayerY                   -format dec
ram_watch   add     0xc004      -type byte      -desc PlayerAnimationFrame      -format hex
ram_watch   add     0xc005      -type byte      -desc PlayerJumpingCounter      -format dec
ram_watch   add     0xc006      -type word      -desc Score                     -format hex
ram_watch   add     0xc008      -type word      -desc HighScore                 -format hex
ram_watch   add     0xc00b      -type byte      -desc FramesSkipped             -format dec

#ram_watch   add     0xc0c0      -type byte      -desc Debug_Temp_Byte             -format dec
#ram_watch   add     0xc0c1      -type word      -desc Debug_Temp_Word             -format dec

#PlayerJumpingCounter