#define GPMCON *((volatile unsigned long*)0x7F008820)
#define GPMDAT *((volatile unsigned long*)0x7F008824)
#define GPMPUD *((volatile unsigned long*)0x7F008828)

int main()
{
	static int flag =12;
	GPMCON = (GPMCON & ~0xffff)|0x1111;
	GPMPUD = (GPMPUD & ~0xff)|0x55;
	GPMDAT = (GPMDAT & ~0x0f)|0x0f;
	if (12 == flag)
	{
		GPMDAT = 0x00;
	}
	else
		GPMDAT = 0x0f;
	while(1);
	return 0;
}