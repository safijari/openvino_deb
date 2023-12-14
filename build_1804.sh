#!/bin/bash
PROJECT_NAME="openvino"
VERSION="2023.1.0"
WORKING_DIR="./working_dir"
TARGET_DIR=${WORKING_DIR}/package_output
OVINO_DIR=${WORKING_DIR}/openvino
RUNTIME_DIR=${WORKING_DIR}/openvino/runtime

rm -rf ${WORKING_DIR}
curl -L https://storage.openvinotoolkit.org/repositories/openvino/packages/2023.1/linux/l_openvino_toolkit_ubuntu18_2023.1.0.12185.47b736f63ed_x86_64.tgz --output /tmp/openvino_2023.1.0.tgz
tar -xf /tmp/openvino_2023.1.0.tgz -C /tmp
mkdir -p ${WORKING_DIR}
mv /tmp/l_openvino_toolkit_ubuntu18_2023.1.0.12185.47b736f63ed_x86_64 ${OVINO_DIR}

mkdir -p ${TARGET_DIR}/DEBIAN
mkdir -p ${TARGET_DIR}/usr/include/${PROJECT_NAME}
mkdir -p ${TARGET_DIR}/usr/lib/${PROJECT_NAME}
mkdir -p ${TARGET_DIR}/usr/share/${PROJECT_NAME}/runtime

cp -r ${RUNTIME_DIR}/include/* ${TARGET_DIR}/usr/include/
cp -r ${RUNTIME_DIR}/lib/intel64/* ${TARGET_DIR}/usr/lib/
cp -r ${RUNTIME_DIR}/* ${TARGET_DIR}/usr/share/${PROJECT_NAME}/runtime/

# Create the control file
sed "s/Version: 1.0.0/Version: ${VERSION}/" control > ${TARGET_DIR}/DEBIAN/control

# Build the Debian package
dpkg-deb --build ${TARGET_DIR}

mv ${TARGET_DIR}/package_output.deb ${WORKING_DIR}/openvino_${VERSION}_1804.deb

echo "Packaging complete. Find the Debian package in the '${TARGET_DIR}' directory."
