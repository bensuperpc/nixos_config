#include <inttypes.h>
#include <stdio.h>

#include "esp_chip_info.h"
#include "esp_flash.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "sdkconfig.h"

void app_main(void)
{
    esp_chip_info_t chip_info;
    esp_chip_info(&chip_info);
    printf("Hello from %s: %d core(s), silicon revision v%d.%d\n", CONFIG_IDF_TARGET, chip_info.cores,
           chip_info.revision / 100, chip_info.revision % 100);

    uint32_t flash_size = 0;
    if (esp_flash_get_size(NULL, &flash_size) == ESP_OK) {
        printf("Flash: %" PRIu32 " MB\n", flash_size / (1024 * 1024));
    }

    for (uint32_t seconds = 0;; seconds++) {
        printf("Uptime: %" PRIu32 " s\n", seconds);
        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}
