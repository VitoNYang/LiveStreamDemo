//
//  CaptureViewController.swift
//  LiveStreamDemo
//
//  Created by hao Mac Mini on 2017/2/4.
//  Copyright © 2017年 Vito.Yang. All rights reserved.
//

import UIKit
import AVFoundation

class CaptureViewController: UIViewController {
    
    var videoConnection: AVCaptureConnection?
    
    var currentVideoDeviceInput: AVCaptureDeviceInput?
    
    var captureSession: AVCaptureSession?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    lazy var focusImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        self.view.addSubview(imageView)
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCaputureVideo()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchHandle(gesture:)))
        
        view.addGestureRecognizer(tapGesture)
    }
    
    func touchHandle(gesture: UITapGestureRecognizer) {
        // 获取点击的坐标
        let location = gesture.location(in: gesture.view)
        // 将当前坐标转换成摄像头上的坐标
        if let cameraPoint = previewLayer?.captureDevicePointOfInterest(for: location) {
            // 设置聚焦光标位置
            setFocusCursor(point: location)
            
            // 设置聚焦
            focus(with: .autoFocus, exposureMode: .autoExpose, at: cameraPoint)
        }
    }
    
    func setFocusCursor(point: CGPoint) {
        focusImageView.center = point
        focusImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        focusImageView.alpha = 1.0
        UIView.animate(withDuration: 1.0, animations: { 
            self.focusImageView.transform = .identity
        }) { (finished) in
            self.focusImageView.alpha = 0
        }
    }
    
    func focus(with mode: AVCaptureFocusMode, exposureMode: AVCaptureExposureMode, at point: CGPoint) {
        let captureDevice = currentVideoDeviceInput?.device
        // 锁定配置
        do {
            try captureDevice?.lockForConfiguration()
        }catch {
            print("error > \(error)")
        }
        
        // 设置聚焦
        if captureDevice?.isFocusModeSupported(.autoFocus) ?? false {
            captureDevice?.focusMode = .autoFocus
        }
        if captureDevice?.isFocusPointOfInterestSupported ?? false {
            captureDevice?.focusPointOfInterest = point
        }
        
        // 设置曝光
        if captureDevice?.isExposureModeSupported(.autoExpose) ?? false {
            captureDevice?.exposureMode = .autoExpose
        }
        if captureDevice?.isFocusPointOfInterestSupported ?? false {
            captureDevice?.exposurePointOfInterest = point
        }
        
        // 解锁配置
        captureDevice?.unlockForConfiguration()
        
    }
    
    // 捕获音视频
    func setupCaputureVideo() {
        // 1, 创建捕获对话
        let captureSession = AVCaptureSession()
        self.captureSession = captureSession
        
        // 2, 获取摄像头设备, 默认是后摄像头
        let videoDevice = getVideoDevice(position: .front) // 获取前摄像头
        
        // 3, 获取声音设备
        let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
        
        // 4, 创建对应视频设备输入对象
        var videoDeviceInput: AVCaptureDeviceInput?
        do {
            videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            currentVideoDeviceInput = videoDeviceInput
        }catch {
            print("error > \(error)")
        }
        
        // 5, 创建对应音频设备输入对象
        var audioDeviceInput: AVCaptureDeviceInput?
        do {
            audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice)
        }catch {
            print("error > \(error)")
        }
        
        // 6, 添加到会话中
        // 注意: 最好判断是否能添加输入，会话不能为空
        // 6.1 添加视频
        if captureSession.canAddInput(videoDeviceInput) {
            captureSession.addInput(videoDeviceInput)
        }
        
        // 6.2 添加音频
        if captureSession.canAddInput(audioDeviceInput) {
            captureSession.addInput(audioDeviceInput)
        }
        
        // 7, 获取视频数据输出设备
        let videoOutput = AVCaptureVideoDataOutput()
        // 7.1 设置代理, 捕获视频样品数据
        // 注意: 队列必须是串行队列, 才能获取到数据, 而且不能为空
        let videoQueue = DispatchQueue(label: "VTVideoCaptureQueue")
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        // 8, 获取音频数据输出设备
        let audioOutput = AVCaptureAudioDataOutput()
        // 注意事项同7
        let audioQueue = DispatchQueue(label: "VTAudioCaptureQueue")
        audioOutput.setSampleBufferDelegate(self, queue: audioQueue)
        if captureSession.canAddOutput(audioOutput) {
            captureSession.addOutput(audioOutput)
        }
        
        // 9, 获取视频输入与输出连接, 用于分辨音视频数据
        videoConnection = videoOutput.connection(withMediaType: AVMediaTypeVideo)
        
        // 10, 添加视频预览图层
        if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
            previewLayer.frame = view.bounds
            
            view.layer.insertSublayer(previewLayer, at: 0)
            self.previewLayer = previewLayer
        }
        
        captureSession.startRunning()
    }
    
    // 指定摄像头方向, 并获取摄像头
    func getVideoDevice(position: AVCaptureDevicePosition) -> AVCaptureDevice?{
        if let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) {
            for tempDevice in devices {
                if let device = tempDevice as? AVCaptureDevice, device.position == position {
                    return device
                }
            }
        }
        return nil
    }
    
    // 切换摄像头
    @IBAction func toggleCapture(sender: UIButton) {
        if let currentPosition = currentVideoDeviceInput?.device.position {
            // 获取需要改变的方向
            let isBack = currentPosition == .back
            let togglePosition: AVCaptureDevicePosition = (isBack ? .front : .back)
            
            // 获取改变的摄像头设备
            let toggleDevice = getVideoDevice(position: togglePosition)
            
            // 获取改变的摄像头输入设备
            do {
                let toggleDeviceInput = try AVCaptureDeviceInput(device: toggleDevice)
                // 移除之前摄像头输入设备
                captureSession?.removeInput(currentVideoDeviceInput)
                
                // 添加新的摄像头输入设备
                captureSession?.addInput(toggleDeviceInput)
                
                // 记录当前摄像头输入设备
                currentVideoDeviceInput = toggleDeviceInput
                
            }catch {
                print("error > \(error)")
            }
        }
    }

}

extension CaptureViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!)
    {
        if videoConnection == connection {
            print("采集到视频数据")
        } else {
            print("采集到音频数据")
        }
    }
}

extension CaptureViewController: AVCaptureAudioDataOutputSampleBufferDelegate {
    
}
