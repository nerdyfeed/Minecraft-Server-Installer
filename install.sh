function Setup() {
	clear
	echo "Добро пожаловать в установщик сервера Minecraft"
	echo "Репозиторий скрипта доступен здесь: https://github.com/nerdyfeed/Minecraft-Server-Installer"
	echo ""
	echo "Что хотите сделать?"
	echo "   1) Добавить сервер"
	echo "   2) Удалить сервер"
	echo "   3) Добавить плагины (beta)"
	echo "   4) Выход"

until [[ "$MENU_OPTION" =~ ^[1-4]$ ]]; do
	read -rp "Выбор [1-4]: " MENU_OPTION
done

case $MENU_OPTION in
	1)
		addServer
	;;
	2)
		removeServer
	;;
	3)
		addPlugins
	;;
	4)
		exit 0
	;;
esac

}

function addServer() {
	clear
	LASTVERSION=1.13.2
	read -p "Введите версию сервера[1.4.6 - $LASTVERSION]: " SERVERVERSION
	read -p "Введите имя: " SERVERNAME
	if [[ -z "$SERVERNAME" || -z "$SERVERVERSION" ]]; then
    	SERVERNAME=MCSERVER
    	SERVERVERSION=$LASTVERSION
	fi
	echo "Установка сервера $SERVERNAME версии $SERVERVERSION в директорию /home"
	mkdir /home/$SERVERNAME
	cd /home/$SERVERNAME
	# CHECK VERSION
	if [ "$SERVERVERSION" == "1.9.4" ]; then
		SERVERVERSION="1.9.4-R0.1-SNAPSHOT-LATEST"
	fi
	if [ "$SERVERVERSION" == "1.8.6" ]; then
		SERVERVERSION="1.8.6-R0.1-SNAPSHOT-LATEST"
	fi
	if [ "$SERVERVERSION" == "1.8" ]; then
		SERVERVERSION="1.8-R0.1-SNAPSHOT-LATEST"
	fi
	if [ "$SERVERVERSION" == "1.7.10" ]; then
		SERVERVERSION="1.7.10-SNAPSHOT-B1657"
	fi
	if [ "$SERVERVERSION" == "1.7.5" ]; then
		SERVERVERSION="1.7.5-R0.1-SNAPSHOT-1387"
	fi
	if [ "$SERVERVERSION" == "1.6.4" ]; then
		SERVERVERSION="1.6.4-R2.1-SNAPSHOT"
	fi
	if [ "$SERVERVERSION" == "1.5.2" ]; then
		SERVERVERSION="1.5.2-R1.1-SNAPSHOT"
	fi
	if [ "$SERVERVERSION" == "1.5.1" ]; then
		SERVERVERSION="1.5.1-R0.1-SNAPSHOT"
	fi
	if [ "$SERVERVERSION" == "1.4.7" ]; then
		SERVERVERSION="1.4.7-R1.1-SNAPSHOT"
	fi
	sudo apt-get -y update
	echo Установка необходимого ПО...
	sudo apt-get -y install screen htop mc unzip && apt-get install -y software-properties-common
	echo Добавление репозитория...
	sudo add-apt-repository -y ppa:webupd8team/java
	sudo apt-get -y update
	echo Установка Java
	echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && sudo apt-get -y install oracle-java8-installer
	echo Загрузка сервера...
	wget https://cdn.getbukkit.org/spigot/spigot-$SERVERVERSION.jar -O spigot.jar
	wget https://uncls.pro/MinecraftServer/cores/$SERVERVERSION.zip
	unzip $SERVERVERSION.zip
	rm $SERVERVERSION.zip
	echo "java -Xms512M -Xmx512M -jar spigot.jar" > /home/$SERVERNAME/start.sh && chmod +x start.sh
	echo "Сервер $SERVERNAME версии $SERVERVERSION установлен!"
}

function removeServer() {
	clear
	read -p "Введите имя сервера: " SERVERNAME
	if [ -z "$SERVERNAME" ]; then
		echo -e "Ввод пуст \n Остановлено"
		exit 0
	else
		if ! [ -d /home/$SERVERNAME ]; then
		echo "Сервер не найден!"
		else
		rm -r /home/$SERVERNAME && echo "Сервер $SERVERNAME удалён!"
	fi
	fi
}

function addPlugins() {
	echo "В разработке..."
}
if [[ $EUID -ne 0 ]]; then
    echo "Скрипт может быть запущен только от имени root."
    exit 1
else
	Setup
fi