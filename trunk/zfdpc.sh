doctrinesvnorm="http://svn.github.com/doctrine/doctrine2.git"
doctrinesvndbal="http://svn.github.com/doctrine/dbal.git"
doctrinesvncommon="http://svn.github.com/doctrine/common.git"
zfsvn="http://framework.zend.com/svn/framework/standard/trunk"
zfdisvn="http://zf-doctrine-integrator.googlecode.com/svn/trunk"

echo "Welcome to the Zend Framework with Doctrine project creator"
echo -n "Please type the name of your project (special chars and spaces aren't recommended...): "
read pname
echo -n "Please type the ABSOLUTE path of the folder, that should contain the project's root folder: "
read proot
echo -n "Please type the local URL under which your project will run: "
read purl

mkdir -p $proot/$pname/temp $proot/$pname/bin
cd $proot/$pname

echo "checking out Zend Framework ... this may take a while."
svn export -q $zfsvn/bin/ ./temp/zf/bin >> /dev/null
svn export -q $zfsvn/library/ ./temp/zf/lib >> /dev/null

echo "checking out Doctrine ORM ... this may take a while."
svn export -q $doctrinesvnorm ./temp/doctrine/orm >> /dev/null

echo "checking out Doctrine DBAL ... this may take a while."
svn export -q $doctrinesvndbal ./temp/doctrine/dbal >> /dev/null

echo "checking out Doctrine DBAL ... this may take a while."
svn export -q $doctrinesvncommon ./temp/doctrine/common >> /dev/null

echo "creating project"
export ZEND_TOOL_INCLUDE_PATH=./temp/zf/lib
./temp/zf/bin/zf.sh create project . >> /dev/null

# copy libraries
echo "copying libraries"
mv ./temp/zf/lib/Zend ./library/Zend
mv ./temp/zf/bin/* ./bin
mv ./temp/doctrine/orm/lib/Doctrine ./library/Doctrine
mv ./temp/doctrine/dbal/lib/Doctrine/DBAL ./library/Doctrine/DBAL
mv ./temp/doctrine/common/lib/Doctrine/Common ./library/Doctrine/Common
mv ./temp/doctrine/orm/lib/vendor ./library/vendor
mv ./temp/doctrine/orm/bin/* ./bin

rm -rf ./temp

echo "checking out doctrine integration files"
svn export -q --force $zfdisvn/integration/ .  >> /dev/null
sed "s#{proot}#$proot/$pname#g" vhost.conf > vhost2.conf
sed "s#{pname}#$pname#g" vhost2.conf > vhost.conf
sed "s#{purl}#$purl#g" vhost.conf > vhost2.conf
rm -rf vhost.conf
mv vhost2.conf vhost.conf

echo "All done !"
echo "To make your newly created project accessable, follow these steps:"
echo "  1. copy the vhost.conf from your project's root folder to the apache conf directory"
echo "  2. restart apache"
echo "  3. add '127.0.0.1 $purl' to your /etc/hosts file"
echo "  4. edit the application/configs/application.ini file and insert your database connection settings"
echo "  5. execute './bin/doctrine orm:schema-tool:create' to create your database tables"
echo "  6. visit $purl to check if everything worked!"