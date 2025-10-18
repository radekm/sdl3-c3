module sdl;

typedef SDL_Sensor = void;

typedef SDL_SensorID = uint;

const float STANDARD_GRAVITY = 9.80665;

enum SDL_SensorType : const CInt
{
    INVALID = -1,  /**< Returned for an invalid sensor */
    UNKNOWN,  /**< Unknown sensor type */
    ACCEL,  /**< Accelerometer */
    GYRO,  /**< Gyroscope */
    ACCEL_L,  /**< Accelerometer for left Joy-Con controller and Wii nunchuk */
    GYRO_L,  /**< Gyroscope for left Joy-Con controller */
    ACCEL_R,  /**< Accelerometer for right Joy-Con controller */
    GYRO_R,  /**< Gyroscope for right Joy-Con controller */
    COUNT,
}


/* Function prototypes */

extern fn SDL_SensorID* get_sensors(CInt* count) @extern("SDL_GetSensors");

extern fn ZString get_sensor_name_for_id(SDL_SensorID instance_id) @extern("SDL_GetSensorNameForID");

extern fn SDL_SensorType get_sensor_type_for_id(SDL_SensorID instance_id) @extern("SDL_GetSensorTypeForID");

extern fn CInt get_sensor_non_portable_type_for_id(SDL_SensorID instance_id) @extern("SDL_GetSensorNonPortableTypeForID");

extern fn SDL_Sensor* open_sensor(SDL_SensorID instance_id) @extern("SDL_OpenSensor");

extern fn SDL_Sensor* get_sensor_from_id(SDL_SensorID instance_id) @extern("SDL_GetSensorFromID");

extern fn SDL_PropertiesID get_sensor_properties(SDL_Sensor* sensor) @extern("SDL_GetSensorProperties");

extern fn ZString get_sensor_name(SDL_Sensor* sensor) @extern("SDL_GetSensorName");

extern fn SDL_SensorType get_sensor_type(SDL_Sensor* sensor) @extern("SDL_GetSensorType");

extern fn CInt get_sensor_non_portable_type(SDL_Sensor* sensor) @extern("SDL_GetSensorNonPortableType");

extern fn SDL_SensorID get_sensor_id(SDL_Sensor* sensor) @extern("SDL_GetSensorID");

extern fn bool get_sensor_data(SDL_Sensor* sensor, float* data, CInt num_values) @extern("SDL_GetSensorData");

extern fn void close_sensor(SDL_Sensor* sensor) @extern("SDL_CloseSensor");

extern fn void update_sensors() @extern("SDL_UpdateSensors");
