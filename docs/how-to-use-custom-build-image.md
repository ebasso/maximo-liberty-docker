## How to use a custom build image.

To install industry solutions e.g. Oil & Gas, Service Providers and the other offerings, you can use a custom Maximo dockerfile which aims to extend the original Maximo installation container. A sample script `custom/Dockerfile` allows to run IBM Installation Manager, unzip Interim Fixes and/or etc at a build time. You can find a Maximo for Oil & Gas sample in the dockerfile. Please uncomment the section in the file to install the Maximo for Oil & Gas V7.6.1 onto Maximo Asset Management V7.6.1.2.

#### Sample steps to install Maximo for Oil and Gas Industry Solution.

1. Uncomment the installation section in `custom/Dockerfile`.
   ```dockerfile
   RUN mkdir /work/oag
   WORKDIR /work/oag
   RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*
   COPY --from=0 /images/Max_Oil_and_Gas_761.zip /work/oag/
   RUN unzip Max_Oil_and_Gas_761.zip && unzip oilandgas_7.6.1_launchpad.zip \
     && /opt/IBM/InstallationManager/eclipse/tools/imcl install com.ibm.tivoli.tpae.IS.OilAndGas \
   -repositories /work/oag/OilAndGasInstallerRepository.zip \
   -installationDirectory /opt/IBM/SMP -acceptLicense && rm -rf /work/oag/*
   COPY --from=0 /images/OG7610_ifixes.20200316-0706.zip /work/oag/
   RUN unzip -o OG7610_ifixes.20200316-0706.zip -d /opt/IBM/SMP/maximo/ && rm -rf /work/oag/*
   ```
2. Put the installation image, e.g. `Max_Oil_and_Gas_761.zip` and `OG7610_ifixes.20200316-0706.zip`, to the ` images` directory.
3. Run the build command with `-c` or `--use-custom-image` option.
   ```bash
   build.sh -c -p -rt
   ```
