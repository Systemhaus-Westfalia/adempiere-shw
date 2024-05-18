# ADempiere Patches
Use this project to publish patches from ADempiere

## How to add a patch?
If you want to add a patch for a adempiere source folder just make the follow:
My example is adding the patch for `org.spin.loan_management`.

The file `settings.gradle` already have the loan management as folder
```
include (':' + rootProject.name + '.investment-and-loan')
project (':' + rootProject.name + '.investment-and-loan').projectDir = file('investment-and-loan')
```

- Add a subfolder named `investment-and-loan`
- Add it `api project(':adempiere-shw.investment-and-loan')` inside main `build.gradle` below of `api project(':adempiere-shw.base')`
- Inside folder add a gradle like the base gradle `base/build.gradle` (you can copy and paste it)
- Change the variable value `def packageName = "base"` by `def packageName = "investment-and-loan"` this is the final package name
- Add a folder `src/main/java`
- Add your patch with package inside folder


## How to add library?

- Go to shw_libs and open `build.gradle`
- Add at last file in `dependences` section your additional library like follow example
```Gradle
	api 'net.minidev:json-smart:2.4.8'
	// https://mvnrepository.com/artifact/net.minidev/accessors-smart
	api 'net.minidev:accessors-smart:2.4.8'
	//	Temporary projects
	//	Keycloak and Okta connector (Open-ID  based)
	api "${baseGroupId}:adempiere-open-id-connector:1.0.0"
    api "<custom-group>:<custom-library>:<custom-version>"
```

All added libraries will be part of complete lib named `com.shw.adempiere-shw.shw_libs`