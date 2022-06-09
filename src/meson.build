forgetpass_sources = [
  'main.vala',
  'crypto.vala',
  'window.vala',
]

forgetpass_deps = [
    dependency('gee-0.8'),
    dependency('gio-2.0', version: '>= 2.50'),
    dependency ('gtk4', version: '>= 4.0.0'),
    dependency('libadwaita-1'),
    declare_dependency (dependencies: [
        meson.get_compiler ('c').find_library ('libgcrypt'),
        meson.get_compiler ('vala').find_library ('gcrypt', dirs: join_paths (meson.current_source_dir (), 'vapi'))
    ])
]

gnome = import('gnome')

executable('com.github.alexkdeveloper.forgetpass', forgetpass_sources,
  include_directories: config_h_dir, 
  vala_args: ['--target-glib=2.50', meson.source_root() + '/src/vapi/config.vapi'], 
  c_args: ['-include', 'config.h'], dependencies: forgetpass_deps,
  install: true,
)
