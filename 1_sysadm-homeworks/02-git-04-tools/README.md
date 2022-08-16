# Домашнее задание к занятию «2.4. Инструменты Git»

Для выполнения заданий в этом разделе давайте склонируем репозиторий с исходным кодом 
терраформа https://github.com/hashicorp/terraform 

В виде результата напишите текстом ответы на вопросы и каким образом эти ответы были получены. 



1. Найдите полный хеш и комментарий коммита, хеш которого начинается на `aefea`.

   Выполняем команду **git show aefea**

   Результат:

   ```
   commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
   Update CHANGELOG.md
   ```

   

2. Какому тегу соответствует коммит `85024d3`?

   Выполняем команду **git show 85024d3**

   Результат:

   ```
   commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)
   ```

   

3. Сколько родителей у коммита `b8d720`? Напишите их хеши.

   Выполняем команду **git show –s –-format=%p b8d720**

   ```
   56cd7859e   9ea88f22f   
   У коммита b8d720 – 2(два) родителя
   ```

   

4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами  v0.12.23 и v0.12.24.

   Выполняем команду **git log v0.12.23..v0.12.24 --oneline**

   Результат:

   ````
   33ff1c03b (tag: v0.12.24) v0.12.24
   b14b74c49 [Website] vmc provider links
   3f235065b Update CHANGELOG.md
   6ae64e247 registry: Fix panic when server is unreachable
   5c619ca1b website: Remove links to the getting started guide's old location
   06275647e Update CHANGELOG.md
   d5f9411f5 command: Fix bug when using terraform login on Windows
   4b6d06cc5 Update CHANGELOG.md
   dd01a3507 Update CHANGELOG.md
   225466bc3 Cleanup after v0.12.23 release
   ````

   

5. Найдите коммит в котором была создана функция `func providerSource`, ее определение в коде выглядит так `func providerSource(...)` (вместо троеточего перечислены аргументы).

  Выполняем команду **git log -S'func providerSource' --oneline**

  Результат:

  ```
  5af1e6234 main: Honor explicit provider_installation CLI config when present
  8c928e835 main: Consult local directories as potential mirrors of providers
  ```

  Далее выполняем команду **git show 8c928e835**

  Результат:

  ```
  +++ b/provider_source.go
  @@ -0,0 +1,89 @@
  +package main
  +
  +import (
  +       "log"
  +       "os"
  +       "path/filepath"
  +
  +       "github.com/apparentlymart/go-userdirs/userdirs"
  +
  +       "github.com/hashicorp/terraform-svchost/disco"
  +       "github.com/hashicorp/terraform/command/cliconfig"
  +       "github.com/hashicorp/terraform/internal/getproviders"
  +)
  +
  +// providerSource constructs a provider source based on a combination of the
  +// CLI configuration and some default search locations. This will be the
  +// provider source used for provider installation in the "terraform init"
  +// command, unless overridden by the special -plugin-dir option.
  +func providerSource(services *disco.Disco) getproviders.Source {
  +       // We're not yet using the CLI config here because we've not implemented
  +       // yet the new configuration constructs to customize provider search
  +       // locations. That'll come later.
  +       // For now, we have a fixed set of search directories:
  +       // - The "terraform.d/plugins" directory in the current working directory,
  +       //   which we've historically documented as a place to put plugins as a
  +       //   way to include them in bundles uploaded to Terraform Cloud, where
  +       //   there has historically otherwise been no way to use custom providers.
  +       // - The "plugins" subdirectory of the CLI config search directory.
  +       //   (thats ~/.terraform.d/plugins on Unix systems, equivalents elsewhere)
  +       // - The "plugins" subdirectory of any platform-specific search paths,
  +       //   following e.g. the XDG base directory specification on Unix systems,
  +       //   Apple's guidelines on OS X, and "known folders" on Windows.
  +       //
  +       // Those directories are checked in addition to the direct upstream
  +       // registry specified in the provider's address.
  +       var searchRules []getproviders.MultiSourceSelector
  +
  +       addLocalDir := func(dir string) {
  +               // We'll make sure the directory actually exists before we add it,
  +               // because otherwise installation would always fail trying to look
  +               // in non-existent directories. (This is done here rather than in
  +               // the source itself because explicitly-selected directories via the
  +               // CLI config, once we have them, _should_ produce an error if they
  +               // don't exist to help users get their configurations right.)
  +               if info, err := os.Stat(dir); err == nil && info.IsDir() {
  +                       log.Printf("[DEBUG] will search for provider plugins in %s", dir)
  +                       searchRules = append(searchRules, getproviders.MultiSourceSelector{
  +                               Source: getproviders.NewFilesystemMirrorSource(dir),
  +                       })
  +               } else {
  +                       log.Printf("[DEBUG] ignoring non-existing provider search directory %s", dir)
  +               }
  +       }
  +
  +       addLocalDir("terraform.d/plugins") // our "vendor" directory
  +       cliConfigDir, err := cliconfig.ConfigDir()
  +       if err != nil {
  +               addLocalDir(filepath.Join(cliConfigDir, "plugins"))
  +       }
  +
  +       // This "userdirs" library implements an appropriate user-specific and
  +       // app-specific directory layout for the current platform, such as XDG Base
  +       // Directory on Unix, using the following name strings to construct a
  +       // suitable application-specific subdirectory name following the
  +       // conventions for each platform:
  +       //
  +       //   XDG (Unix): lowercase of the first string, "terraform"
  +       //   Windows:    two-level heirarchy of first two strings, "HashiCorp\Terraform"
  +       //   OS X:       reverse-DNS unique identifier, "io.terraform".
  +       sysSpecificDirs := userdirs.ForApp("Terraform", "HashiCorp", "io.terraform")
  +       for _, dir := range sysSpecificDirs.DataSearchPaths("plugins") {
  +               addLocalDir(dir)
  +       }
  +
  +       // Last but not least, the main registry source! We'll wrap a caching
  +       // layer around this one to help optimize the several network requests
  +       // we'll end up making to it while treating it as one of several sources
  +       // in a MultiSource (as recommended in the MultiSource docs).
  +       // This one is listed last so that if a particular version is available
  +       // both in one of the above directories _and_ in a remote registry, the
  +       // local copy will take precedence.
  +       searchRules = append(searchRules, getproviders.MultiSourceSelector{
  +               Source: getproviders.NewMemoizeSource(
  +                       getproviders.NewRegistrySource(services),
  +               ),
  +       })
  +
  +       return getproviders.MultiSource(searchRules)
  +}
  ```

  Ввиду вышеуказанного, в коммите 8c928e835 была создана функция func providerSource.

  

6. Найдите все коммиты в которых была изменена функция `globalPluginDirs`.

   Выполняем команду **git log -S'func globalPluginDirs' --oneline**

   Результат: 

   ```
   commit 8364383c359a6b738a436d1b7745ccdce178df47
   Author: Martin Atkins <mart@degeneration.co.uk>
   Date:   Thu Apr 13 18:05:58 2017 -0700
   ```

   Выполняем команду **git show 8364383c3**

   ```
   diff --git a/plugins.go b/plugins.go
   new file mode 100644
   index 000000000..9717724a0
   --- /dev/null
   +++ b/plugins.go
   @@ -0,0 +1,37 @@
   +package main
   +
   +import (
   +       "log"
   +       "path/filepath"
   +
   +       "github.com/kardianos/osext"
   +)
   +
   +// globalPluginDirs returns directories that should be searched for
   +// globally-installed plugins (not specific to the current configuration).
   +//
   +// Earlier entries in this slice get priority over later when multiple copies
   +// of the same plugin version are found, but newer versions always override
   +// older versions where both satisfy the provider version constraints.
   +func globalPluginDirs() []string {
   +       var ret []string
   +
   +       // Look in the same directory as the Terraform executable.
   +       // If found, this replaces what we found in the config path.
   +       exePath, err := osext.Executable()
   +       if err != nil {
   +               log.Printf("[ERROR] Error discovering exe directory: %s", err)
   +       } else {
   +               ret = append(ret, filepath.Dir(exePath))
   +       }
   +
   +       // Look in ~/.terraform.d/plugins/ , or its equivalent on non-UNIX
   +       dir, err := ConfigDir()
   +       if err != nil {
   +               log.Printf("[ERROR] Error finding global config directory: %s", err)
   +       } else {
   +               ret = append(ret, filepath.Join(dir, "plugins"))
   +       }
   +
   +       return ret
   +}
   ```

   Убеждаемся что функция globalPluginDirs была создана в коммите 8364383c3 и эта функция была описана в новом файле plugins.go.

   Выполняем команду **git log -L:globalPluginDirs:plugins.go --oneline**

   Результат:

   ```
       Получаем и находим количество коммитов с данной функцией:
   78b122055 Remove config.go and update things using its aliases
    
   diff --git a/plugins.go b/plugins.go
   --- a/plugins.go
   +++ b/plugins.go
   @@ -16,14 +18,14 @@
    func globalPluginDirs() []string {
           var ret []string
           // Look in ~/.terraform.d/plugins/ , or its equivalent on non-UNIX
   -       dir, err := ConfigDir()
   +       dir, err := cliconfig.ConfigDir()
           if err != nil {
                   log.Printf("[ERROR] Error finding global config directory: %s", err)
           } else {
                   machineDir := fmt.Sprintf("%s_%s", runtime.GOOS, runtime.GOARCH)
                   ret = append(ret, filepath.Join(dir, "plugins"))
                   ret = append(ret, filepath.Join(dir, "plugins", machineDir))
           }
    
           return ret
    }
   52dbf9483 keep .terraform.d/plugins for discovery
    
   diff --git a/plugins.go b/plugins.go
   --- a/plugins.go
   +++ b/plugins.go
   @@ -16,13 +16,14 @@
    func globalPluginDirs() []string {
           var ret []string
           // Look in ~/.terraform.d/plugins/ , or its equivalent on non-UNIX
           dir, err := ConfigDir()
           if err != nil {
                   log.Printf("[ERROR] Error finding global config directory: %s", err)
           } else {
                   machineDir := fmt.Sprintf("%s_%s", runtime.GOOS, runtime.GOARCH)
   +               ret = append(ret, filepath.Join(dir, "plugins"))
                   ret = append(ret, filepath.Join(dir, "plugins", machineDir))
           }
    
           return ret
    }
   41ab0aef7 Add missing OS_ARCH dir to global plugin paths
    
   diff --git a/plugins.go b/plugins.go
   --- a/plugins.go
   +++ b/plugins.go
   @@ -14,12 +16,13 @@
    func globalPluginDirs() []string {
           var ret []string
           // Look in ~/.terraform.d/plugins/ , or its equivalent on non-UNIX
           dir, err := ConfigDir()
           if err != nil {
                   log.Printf("[ERROR] Error finding global config directory: %s", err)
           } else {
   -               ret = append(ret, filepath.Join(dir, "plugins"))
   +               machineDir := fmt.Sprintf("%s_%s", runtime.GOOS, runtime.GOARCH)
   +               ret = append(ret, filepath.Join(dir, "plugins", machineDir))
           }
    
           return ret
    }
   66ebff90c move some more plugin search path logic to command
    
   diff --git a/plugins.go b/plugins.go
   --- a/plugins.go
   +++ b/plugins.go
   @@ -16,22 +14,12 @@
    func globalPluginDirs() []string {
           var ret []string
   -
   -       // Look in the same directory as the Terraform executable.
   -       // If found, this replaces what we found in the config path.
   -       exePath, err := osext.Executable()
   -       if err != nil {
   -               log.Printf("[ERROR] Error discovering exe directory: %s", err)
   -       } else {
   -               ret = append(ret, filepath.Dir(exePath))
   -       }
   -
           // Look in ~/.terraform.d/plugins/ , or its equivalent on non-UNIX
           dir, err := ConfigDir()
           if err != nil {
                   log.Printf("[ERROR] Error finding global config directory: %s", err)
           } else {
                   ret = append(ret, filepath.Join(dir, "plugins"))
           }
    
           return ret
    }
   8364383c3 Push plugin discovery down into command package
    
   diff --git a/plugins.go b/plugins.go
   --- /dev/null
   +++ b/plugins.go
   @@ -0,0 +16,22 @@
   +func globalPluginDirs() []string {
   +       var ret []string
   +
   +       // Look in the same directory as the Terraform executable.
   +       // If found, this replaces what we found in the config path.
   +       exePath, err := osext.Executable()
   +       if err != nil {
   +               log.Printf("[ERROR] Error discovering exe directory: %s", err)
   +       } else {
   +               ret = append(ret, filepath.Dir(exePath))
   +       }
   +
   +       // Look in ~/.terraform.d/plugins/ , or its equivalent on non-UNIX
   +       dir, err := ConfigDir()
   +       if err != nil {
   +               log.Printf("[ERROR] Error finding global config directory: %s", err)
   +       } else {
   +               ret = append(ret, filepath.Join(dir, "plugins"))
   +       }
   +
   +       return ret
   +}
   ```

   Всего получилось 5 коммитов.

   Исключаем 8364383c3, т.к. в нем функция была создана.

   Все коммиты в которых были изменения в функции globalPluginDirs – 4 шт.

   78b122055 Remove config.go and update things using its aliases

   52dbf9483 keep .terraform.d/plugins for discovery

   41ab0aef7 Add missing OS_ARCH dir to global plugin paths

   66ebff90c move some more plugin search path logic to command

   

7. Кто автор функции `synchronizedWriters`? 

   Выполняем команду **git log -S'func synchronizedWriters ' --oneline**

   Результат:

   ```
   bdfea50cc remove unused
   5ac311e2a main: synchronize writes to VT100-faker on Windows
   ```

   Выполняем команду **git show 5ac311e2a**

   ```
   commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5
   Author: Martin Atkins <mart@degeneration.co.uk>
   Date:   Wed May 3 16:25:41 2017 -0700
    
       main: synchronize writes to VT100-faker on Windows
       
       We use a third-party library "colorable" to translate VT100 color
       sequences into Windows console attribute-setting calls when Terraform is
       running on Windows.
       
       colorable is not concurrency-safe for multiple writes to the same console,
       because it writes to the console one character at a time and so two
       concurrent writers get their characters interleaved, creating unreadable
       garble.
       
       Here we wrap around it a synchronization mechanism to ensure that there
       can be only one Write call outstanding across both stderr and stdout,
       mimicking the usual behavior we expect (when stderr/stdout are a normal
       file handle) of each Write being completed atomically.
    
   diff --git a/main.go b/main.go
   index b94de2ebc..237581200 100644
   --- a/main.go
   +++ b/main.go
   @@ -258,6 +258,15 @@ func copyOutput(r io.Reader, doneCh chan<- struct{}) {
           if runtime.GOOS == "windows" {
                   stdout = colorable.NewColorableStdout()
                   stderr = colorable.NewColorableStderr()
   +
   +               // colorable is not concurrency-safe when stdout and stderr are the
   +               // same console, so we need to add some synchronization to ensure that
   +               // we can't be concurrently writing to both stderr and stdout at
   +               // once, or else we get intermingled writes that create gibberish
   +               // in the console.
   +               wrapped := synchronizedWriters(stdout, stderr)
   +               stdout = wrapped[0]
   +               stderr = wrapped[1]
           }
    
           var wg sync.WaitGroup
   diff --git a/synchronized_writers.go b/synchronized_writers.go
   new file mode 100644
   index 000000000..2533d1316
   --- /dev/null
   +++ b/synchronized_writers.go
   @@ -0,0 +1,31 @@
   +package main
   +
   +import (
   +       "io"
   +       "sync"
   +)
   +
   +type synchronizedWriter struct {
   +       io.Writer
   +       mutex *sync.Mutex
   +}
   +
   +// synchronizedWriters takes a set of writers and returns wrappers that ensure
   +// that only one write can be outstanding at a time across the whole set.
   +func synchronizedWriters(targets ...io.Writer) []io.Writer {
   +       mutex := &sync.Mutex{}
   +       ret := make([]io.Writer, len(targets))
   +       for i, target := range targets {
   +               ret[i] = &synchronizedWriter{
   +                       Writer: target,
   +                       mutex:  mutex,
   +               }
   +       }
   +       return ret
   +}
   +
   +func (w *synchronizedWriter) Write(p []byte) (int, error) {
   +       w.mutex.Lock()
   +       defer w.mutex.Unlock()
   +       return w.Writer.Write(p)
   +}

Убеждаемся, что в данном коммите была создана функция synchronizedWriters и новый файл synchronized_writers.go.

Автор функции synchronizedWriters:

commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5

Author: Martin Atkins <mart@degeneration.co.uk>
