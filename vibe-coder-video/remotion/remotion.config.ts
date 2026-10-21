import { Config } from "@remotion/cli/config";

Config.setVideoImageFormat("png");
Config.setJpegQuality(100);
Config.setConcurrency(4);
Config.setFrameRate(30);
Config.setPixelFormat("yuv420p");
Config.setCodec("h264");
Config.setCrf(18);
Config.setAudioBitrate("192k");
Config.setLogLevel("info");
Config.setOverwriteOutput(true);
