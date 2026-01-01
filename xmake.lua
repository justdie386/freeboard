add_rules("mode.debug", "mode.release")

if is_plat("linux") then
	add_requires("dbus")
end

target("app")
    add_files("src/*.c", "src/osx/*.m")
    if (is_plat("macosx")) then
	add_files("src/osx/*.m")
	add_frameworks("ApplicationServices", "Foundation")
    end
    if (is_plat("linux")) then
	add_files("src/unix/*.c")
	add_packages("dbus")
    end

    add_headerfiles("src/*.h")
