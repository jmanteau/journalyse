define netinstall (
  $url,
  $destination_dir,
  $extracted_dir = '',
  $owner = 'root',
  $group = 'root',
  $work_dir = '/var/tmp',
  $path = '/bin:/sbin:/usr/bin:/usr/sbin',
  $extract_command = '',
  $preextract_command = '',
  $postextract_command = '',
  $exec_env = [],
  ) {

  $source_filename = url_parse($url,'filename')
  $source_filetype = url_parse($url,'filetype')
  $source_dirname = url_parse($url,'filedir')

  $real_extract_command = $extract_command ? {
    '' => $source_filetype ? {
      '.tgz' => 'tar -zxf',
      '.tar.gz' => 'tar -zxf',
      '.tar.bz2' => 'tar -jxf',
      '.tar' => 'tar -xf',
      '.zip' => 'unzip',
      default => 'tar -zxf',
    },
    default => $extract_command,
  }

  $extract_command_second_arg = $real_extract_command ? {
    /^cp.*/ => '.',
    /^rsync.*/ => '.',
    default => '',
  }

  $real_extracted_dir = $extracted_dir ? {
    '' => $real_extract_command ? {
      /(^cp.*|^rsync.*)/ => $source_filename,
      default => $source_dirname,
    },
    default => $extracted_dir,
  }

  if $preextract_command {
    exec { "PreExtract $source_filename":
      command => $preextract_command,
      before => Exec["Extract $source_filename"],
      refreshonly => true,
      path => $path,
      environment => $exec_env,
    }
  }

  exec { "Retrieve $url":
    cwd => $work_dir,
    command => "wget $url",
    creates => "$work_dir/$source_filename",
    timeout => 3600,
    path => $path,
    environment => $exec_env,
  }

  exec { "Extract $source_filename":
    command => "mkdir -p $destination_dir && cd $destination_dir && $real_extract_command $work_dir/$source_filename $extract_command_second_arg",
    unless => "ls ${destination_dir}/${real_extracted_dir}",
    creates => "${destination_dir}/${real_extracted_dir}",
    require => Exec["Retrieve $url"],
    path => $path,
    environment => $exec_env,
    notify => Exec["Chown $source_filename"],
  }

  exec { "Chown $source_filename":
    command => "chown -R $owner:$group $destination_dir/$real_extracted_dir",
    refreshonly => true,
    require => Exec["Extract $source_filename"],
    path => $path,
    environment => $exec_env,
  }

  exec { "Delete $work_dir/$source_filename":
    command => "rm -rf ${work_dir}/${source_filename}",
    timeout => 3600,
    path => $path,
    environment => $exec_env,
  }

  if $postextract_command {
    exec { "PostExtract $source_filename":
      command => $postextract_command,
      cwd => "$destination_dir/$real_extracted_dir",
      subscribe => Exec["Extract $source_filename"],
      refreshonly => true,
      timeout => 3600,
      require => Exec["Retrieve $url"],
      path => $path,
      environment => $exec_env,
    }
  }

}
